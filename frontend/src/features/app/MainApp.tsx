import { FormEvent, useEffect, useMemo, useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { ArrowLeft, Camera, Check, Plus, Trash2 } from 'lucide-react';
import { FridgePhotoMockupOverlay } from '../fridge-photo/FridgePhotoMockupOverlay';
import { ShoppingPhotoMockupOverlay } from '../shopping-photo/ShoppingPhotoMockupOverlay';
import { api } from '../../api/client';
import { formatDate, formatQuantity, isExpiringSoon } from '../inventory/formatting';
import { InventoryInput, InventoryItem } from '../inventory/types';
import { RecipeCard } from '../recipes/RecipeCard';
import { RecipePager } from '../recipes/RecipePager';
import { RecipeSuggestion } from '../recipes/types';
import { ShoppingListInput, ShoppingListItem } from '../shopping-list/types';

const units = ['count', 'g', 'kg', 'ml', 'l', 'oz', 'lb', 'cup', 'tbsp', 'tsp'];

type MainTab = 'inStock' | 'shopping';

const emptyInventoryForm: InventoryInput = { name: '', quantity: 1, unit: 'count', expiryDate: null };
const emptyShoppingForm: ShoppingListInput = { name: '', quantity: 1, unit: 'count' };

export function MainApp() {
  const queryClient = useQueryClient();
  const [tab, setTab] = useState<MainTab>('inStock');
  const [inventoryForm, setInventoryForm] = useState<InventoryInput>(emptyInventoryForm);
  const [shoppingForm, setShoppingForm] = useState<ShoppingListInput>(emptyShoppingForm);
  const [fridgePhotoOpen, setFridgePhotoOpen] = useState(false);
  const [shoppingPhotoOpen, setShoppingPhotoOpen] = useState(false);
  const [recipeIndex, setRecipeIndex] = useState(0);
  const [movingItemId, setMovingItemId] = useState<string | null>(null);
  const [moveExpiryDate, setMoveExpiryDate] = useState<string>('');

  const inventory = useQuery({
    queryKey: ['inventory'],
    queryFn: () => api.get<InventoryItem[]>('/api/inventory'),
  });

  const shoppingList = useQuery({
    queryKey: ['shopping-list'],
    queryFn: () => api.get<ShoppingListItem[]>('/api/shopping-list'),
  });

  const suggestions = useQuery({
    queryKey: ['recipe-suggestions'],
    queryFn: () => api.get<RecipeSuggestion[]>('/api/recipes/suggestions'),
  });

  const invalidateMain = async () => {
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ['inventory'] }),
      queryClient.invalidateQueries({ queryKey: ['shopping-list'] }),
      queryClient.invalidateQueries({ queryKey: ['recipe-suggestions'] }),
    ]);
  };

  const createInventory = useMutation({
    mutationFn: (input: InventoryInput) => api.post<InventoryItem>('/api/inventory', input),
    onSuccess: async () => {
      setInventoryForm(emptyInventoryForm);
      await invalidateMain();
    },
  });

  const deleteInventory = useMutation({
    mutationFn: (id: string) => api.delete<void>(`/api/inventory/${id}`),
    onSuccess: invalidateMain,
  });

  const createShopping = useMutation({
    mutationFn: (input: ShoppingListInput) => api.post<ShoppingListItem>('/api/shopping-list', input),
    onSuccess: async () => {
      setShoppingForm(emptyShoppingForm);
      await invalidateMain();
    },
  });

  const deleteShopping = useMutation({
    mutationFn: (id: string) => api.delete<void>(`/api/shopping-list/${id}`),
    onSuccess: invalidateMain,
  });

  const moveToInventory = useMutation({
    mutationFn: ({ id, expiryDate }: { id: string; expiryDate: string | null }) =>
      api.post<InventoryItem>(`/api/shopping-list/${id}/move-to-inventory`, { expiryDate }),
    onSuccess: async () => {
      setMovingItemId(null);
      setMoveExpiryDate('');
      await invalidateMain();
      setTab('inStock');
    },
  });

  const acceptRecipe = useMutation({
    mutationFn: ({ recipeId, servingMultiplier }: { recipeId: string; servingMultiplier: number }) =>
      api.post('/api/recipe-sessions', { recipeId, servingMultiplier }),
    onSuccess: invalidateMain,
  });

  const recipes = suggestions.data ?? [];
  const activeRecipe = recipes[recipeIndex] ?? null;
  const activeItemCount = tab === 'inStock' ? inventory.data?.length ?? 0 : shoppingList.data?.length ?? 0;
  const statusLabel =
    tab === 'inStock'
      ? `${activeItemCount} in stock`
      : `${activeItemCount} to buy`;
  const headline =
    tab === 'inStock'
      ? 'Fridge inventory that cooks itself down.'
      : 'Shopping List that stock your fridge up';

  const expiringCount = useMemo(
    () => inventory.data?.filter((item) => isExpiringSoon(item)).length ?? 0,
    [inventory.data],
  );

  useEffect(() => {
    if (recipeIndex >= recipes.length) {
      setRecipeIndex(Math.max(0, recipes.length - 1));
    }
  }, [recipeIndex, recipes.length]);

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.target instanceof HTMLInputElement || event.target instanceof HTMLSelectElement) {
        return;
      }

      if (event.key === 'ArrowLeft') {
        setRecipeIndex((current) => Math.max(0, current - 1));
      }

      if (event.key === 'ArrowRight') {
        setRecipeIndex((current) => Math.min(recipes.length - 1, current + 1));
      }
    };

    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [recipes.length]);

  const submitInventory = (event: FormEvent) => {
    event.preventDefault();
    createInventory.mutate({
      ...inventoryForm,
      name: inventoryForm.name.trim(),
      quantity: Math.round(inventoryForm.quantity),
      expiryDate: inventoryForm.expiryDate || null,
    });
  };

  const submitShopping = (event: FormEvent) => {
    event.preventDefault();
    createShopping.mutate({
      ...shoppingForm,
      name: shoppingForm.name.trim(),
      quantity: Math.round(shoppingForm.quantity),
      sourceRecipeId: shoppingForm.sourceRecipeId ?? null,
    });
  };

  const addRecipeLineToList = (payload: { name: string; quantity: number; unit: string; sourceRecipeId?: string }) => {
    createShopping.mutate({
      name: payload.name,
      quantity: Math.max(1, Math.round(payload.quantity)),
      unit: payload.unit,
      sourceRecipeId: payload.sourceRecipeId ?? null,
    });
  };

  const startMove = (itemId: string) => {
    setMovingItemId(itemId);
    setMoveExpiryDate('');
  };

  const confirmMove = (itemId: string) => {
    moveToInventory.mutate({
      id: itemId,
      expiryDate: moveExpiryDate || null,
    });
  };

  const mutationError =
    (createInventory.error ??
      createShopping.error ??
      moveToInventory.error ??
      acceptRecipe.error ??
      deleteInventory.error ??
      deleteShopping.error) as Error | null;

  return (
    <main className="app-shell">
      <div className="main-column">
        <header className="topbar">
          <p className="eyebrow">TRUESIGHT V2.1</p>
          <h1>{headline}</h1>
        </header>

        <div className="status-pill status-pill-bar">{statusLabel}</div>
        <div className="tab-bar" role="tablist" aria-label="Inventory views">
          <button
            type="button"
            role="tab"
            aria-selected={tab === 'inStock'}
            className={tab === 'inStock' ? 'tab-button active' : 'tab-button'}
            onClick={() => setTab('inStock')}
          >
            In Stock
          </button>
          <button
            type="button"
            role="tab"
            aria-selected={tab === 'shopping'}
            className={tab === 'shopping' ? 'tab-button active' : 'tab-button'}
            onClick={() => setTab('shopping')}
          >
            Shopping List
          </button>
        </div>

        <section className="panel inventory-panel">
          {tab === 'inStock' ? (
            <>
              <div className="panel-heading">
                <h2>In Stock</h2>
                {expiringCount > 0 ? <span className="tab-hint">{expiringCount} expiring soon</span> : null}
              </div>

              <form className="item-form" onSubmit={submitInventory}>
                <label className="field-label field-full">
                  Ingredient
                  <input
                    placeholder="e.g. milk"
                    value={inventoryForm.name}
                    onChange={(event) => setInventoryForm((current) => ({ ...current, name: event.target.value }))}
                    required
                  />
                </label>
                <QuantityUnitFields
                  quantity={inventoryForm.quantity}
                  unit={inventoryForm.unit}
                  units={units}
                  onQuantityChange={(quantity) => setInventoryForm((current) => ({ ...current, quantity }))}
                  onUnitChange={(unit) => setInventoryForm((current) => ({ ...current, unit }))}
                  onAdjust={(delta) =>
                    setInventoryForm((current) => ({
                      ...current,
                      quantity: Math.max(0, Math.round(current.quantity) + delta),
                    }))
                  }
                />
                <label className="field-label field-full">
                  Expiry date
                  <input
                    type="date"
                    value={inventoryForm.expiryDate ?? ''}
                    onChange={(event) =>
                      setInventoryForm((current) => ({ ...current, expiryDate: event.target.value || null }))
                    }
                  />
                </label>
                <div className="add-actions-row field-full">
                  <button className="primary-action add-submit" type="submit" disabled={createInventory.isLoading}>
                    <Plus size={18} />
                    Add
                  </button>
                  <button
                    type="button"
                    className="camera-demo-button"
                    title="Try fridge photo preview (sample image)"
                    aria-label="Try fridge photo preview (sample image, not a real scan)"
                    onClick={() => setFridgePhotoOpen(true)}
                  >
                    <Camera size={20} />
                    <span className="demo-badge">Preview</span>
                  </button>
                </div>
              </form>

              <div className="item-list">
                {inventory.data?.map((item) => (
                  <article className={isExpiringSoon(item) ? 'inventory-item urgent' : 'inventory-item'} key={item.id}>
                    <div>
                      <h3>{item.name}</h3>
                      <p>
                        {formatQuantity(item.quantity)} {item.unit}
                        {item.expiryDate ? ` · expires ${formatDate(item.expiryDate)}` : ''}
                      </p>
                    </div>
                    <button
                      className="icon-button"
                      onClick={() => deleteInventory.mutate(item.id)}
                      aria-label={`Delete ${item.name}`}
                    >
                      <Trash2 size={18} />
                    </button>
                  </article>
                ))}
                {inventory.data?.length === 0 ? (
                  <EmptyState text="Add ingredients to unlock recipe suggestions." />
                ) : null}
              </div>
            </>
          ) : (
            <>
              <div className="panel-heading">
                <h2>Shopping List</h2>
              </div>

              <form className="item-form" onSubmit={submitShopping}>
                <label className="field-label field-full">
                  Ingredient
                  <input
                    placeholder="e.g. spinach"
                    value={shoppingForm.name}
                    onChange={(event) => setShoppingForm((current) => ({ ...current, name: event.target.value }))}
                    required
                  />
                </label>
                <QuantityUnitFields
                  quantity={shoppingForm.quantity}
                  unit={shoppingForm.unit}
                  units={units}
                  onQuantityChange={(quantity) => setShoppingForm((current) => ({ ...current, quantity }))}
                  onUnitChange={(unit) => setShoppingForm((current) => ({ ...current, unit }))}
                  onAdjust={(delta) =>
                    setShoppingForm((current) => ({
                      ...current,
                      quantity: Math.max(0, Math.round(current.quantity) + delta),
                    }))
                  }
                />
                <div className="add-actions-row field-full">
                  <button className="primary-action add-submit" type="submit" disabled={createShopping.isLoading}>
                    <Plus size={18} />
                    Add
                  </button>
                  <button
                    type="button"
                    className="camera-demo-button"
                    title="Try shopping photo preview (sample product image)"
                    aria-label="Try shopping photo preview (sample product image, not a real scan)"
                    onClick={() => setShoppingPhotoOpen(true)}
                  >
                    <Camera size={20} />
                    <span className="demo-badge">Preview</span>
                  </button>
                </div>
              </form>

              <div className="item-list">
                {shoppingList.data?.map((item) => (
                  <article className="inventory-item shopping-item" key={item.id}>
                    <div>
                      <h3>{item.name}</h3>
                      <p>
                        {formatQuantity(item.quantity)} {item.unit}
                      </p>
                      {movingItemId === item.id ? (
                        <label className="field-label move-expiry-field">
                          Expiry when moving (optional)
                          <input
                            type="date"
                            value={moveExpiryDate}
                            onChange={(event) => setMoveExpiryDate(event.target.value)}
                          />
                        </label>
                      ) : null}
                    </div>
                    <div className="shopping-item-actions">
                      {movingItemId === item.id ? (
                        <button
                          type="button"
                          className="icon-button move-to-stock-button"
                          disabled={moveToInventory.isLoading}
                          aria-label={`Confirm move ${item.name} to in stock`}
                          onClick={() => confirmMove(item.id)}
                        >
                          <Check size={18} />
                        </button>
                      ) : (
                        <button
                          type="button"
                          className="icon-button move-to-stock-button"
                          aria-label={`Move ${item.name} to in stock`}
                          onClick={() => startMove(item.id)}
                        >
                          <ArrowLeft size={18} />
                        </button>
                      )}
                      <button
                        type="button"
                        className="icon-button"
                        onClick={() => deleteShopping.mutate(item.id)}
                        aria-label={`Delete ${item.name}`}
                      >
                        <Trash2 size={18} />
                      </button>
                    </div>
                  </article>
                ))}
                {shoppingList.data?.length === 0 ? (
                  <EmptyState text="Add items you plan to buy, then move them into stock after shopping." />
                ) : null}
              </div>
            </>
          )}
        </section>

        <section className="panel recipe-panel recipe-pager-panel">
          {activeRecipe ? (
            <RecipePager index={recipeIndex} total={recipes.length} onIndexChange={setRecipeIndex}>
              <RecipeCard
                recipe={activeRecipe}
                isAccepting={acceptRecipe.isLoading}
                isAddingToList={createShopping.isLoading}
                onAccept={(recipeId, servingMultiplier) => acceptRecipe.mutate({ recipeId, servingMultiplier })}
                onAddToList={addRecipeLineToList}
              />
            </RecipePager>
          ) : (
            <>
              <div className="panel-heading">
                <h2>Suggested Recipe</h2>
              </div>
              <EmptyState text="Add ingredients to unlock recipe suggestions." />
            </>
          )}
        </section>

        <footer className="site-footer">
          <a className="site-footer-link" href="/about.html">
            About Fridge Chef
          </a>
        </footer>
      </div>

      {fridgePhotoOpen ? (
        <FridgePhotoMockupOverlay
          units={units}
          onClose={() => setFridgePhotoOpen(false)}
          onSaved={invalidateMain}
          postItem={(input) => api.post<InventoryItem>('/api/inventory', input)}
        />
      ) : null}

      {shoppingPhotoOpen ? (
        <ShoppingPhotoMockupOverlay
          units={units}
          onClose={() => setShoppingPhotoOpen(false)}
          onSaved={invalidateMain}
          postItem={(input) => api.post<ShoppingListItem>('/api/shopping-list', input)}
        />
      ) : null}

      {mutationError ? (
        <div className="toast" role="alert">
          {mutationError.message}
        </div>
      ) : null}
    </main>
  );
}

type QuantityUnitFieldsProps = {
  quantity: number;
  unit: string;
  units: string[];
  onQuantityChange: (quantity: number) => void;
  onUnitChange: (unit: string) => void;
  onAdjust: (delta: number) => void;
};

function QuantityUnitFields({ quantity, unit, units, onQuantityChange, onUnitChange, onAdjust }: QuantityUnitFieldsProps) {
  return (
    <div className="field-row quantity-unit-row field-full">
      <div className="field-label quantity-field">
        <span>Quantity</span>
        <div className="quantity-stepper">
          <button
            type="button"
            className="stepper-button"
            aria-label="Decrease quantity"
            disabled={quantity <= 0}
            onClick={() => onAdjust(-1)}
          >
            −
          </button>
          <input
            aria-label="Quantity"
            type="number"
            min="0"
            step="1"
            value={quantity}
            onChange={(event) => onQuantityChange(Math.max(0, Math.round(Number(event.target.value) || 0)))}
            required
          />
          <button type="button" className="stepper-button" aria-label="Increase quantity" onClick={() => onAdjust(1)}>
            +
          </button>
        </div>
      </div>
      <label className="field-label">
        Unit
        <select value={unit} onChange={(event) => onUnitChange(event.target.value)}>
          {units.map((option) => (
            <option key={option}>{option}</option>
          ))}
        </select>
      </label>
    </div>
  );
}

function EmptyState({ text }: { text: string }) {
  return <p className="empty-state">{text}</p>;
}
