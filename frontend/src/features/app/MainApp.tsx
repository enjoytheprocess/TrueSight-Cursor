import { FormEvent, useMemo, useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Camera, Plus, Trash2 } from 'lucide-react';
import { FridgePhotoMockupOverlay } from '../fridge-photo/FridgePhotoMockupOverlay';
import { api } from '../../api/client';
import { formatDate, formatQuantity, isExpiringSoon } from '../inventory/formatting';
import { InventoryInput, InventoryItem } from '../inventory/types';
import { RecipeCard } from '../recipes/RecipeCard';
import { RecipeSession, RecipeSuggestion } from '../recipes/types';

const units = ['count', 'g', 'kg', 'ml', 'l', 'oz', 'lb', 'cup', 'tbsp', 'tsp'];

export function MainApp() {
  const queryClient = useQueryClient();
  const [form, setForm] = useState<InventoryInput>({ name: '', quantity: 1, unit: 'count', expiryDate: null });
  const [fridgePhotoOpen, setFridgePhotoOpen] = useState(false);

  const inventory = useQuery({
    queryKey: ['inventory'],
    queryFn: () => api.get<InventoryItem[]>('/api/inventory'),
  });

  const suggestions = useQuery({
    queryKey: ['recipe-suggestions'],
    queryFn: () => api.get<RecipeSuggestion[]>('/api/recipes/suggestions'),
  });

  const sessions = useQuery({
    queryKey: ['recipe-sessions'],
    queryFn: () => api.get<RecipeSession[]>('/api/recipe-sessions'),
  });

  const invalidateV1 = async () => {
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ['inventory'] }),
      queryClient.invalidateQueries({ queryKey: ['recipe-suggestions'] }),
      queryClient.invalidateQueries({ queryKey: ['recipe-sessions'] }),
    ]);
  };

  const createItem = useMutation({
    mutationFn: (input: InventoryInput) => api.post<InventoryItem>('/api/inventory', input),
    onSuccess: async () => {
      setForm({ name: '', quantity: 1, unit: 'count', expiryDate: null });
      await invalidateV1();
    },
  });

  const deleteItem = useMutation({
    mutationFn: (id: string) => api.delete<void>(`/api/inventory/${id}`),
    onSuccess: invalidateV1,
  });

  const acceptRecipe = useMutation({
    mutationFn: ({ recipeId, servingMultiplier }: { recipeId: string; servingMultiplier: number }) =>
      api.post<RecipeSession>('/api/recipe-sessions', { recipeId, servingMultiplier }),
    onSuccess: invalidateV1,
  });

  const expiringCount = useMemo(
    () => inventory.data?.filter((item) => isExpiringSoon(item)).length ?? 0,
    [inventory.data],
  );

  const adjustQuantity = (delta: number) => {
    setForm((current) => ({
      ...current,
      quantity: Math.max(0, Math.round(current.quantity) + delta),
    }));
  };

  const submitInventory = (event: FormEvent) => {
    event.preventDefault();
    createItem.mutate({
      ...form,
      name: form.name.trim(),
      quantity: Math.round(form.quantity),
      expiryDate: form.expiryDate || null,
    });
  };

  return (
    <main className="app-shell">
      <header className="topbar">
        <div>
          <p className="eyebrow">TrueSight V1</p>
          <h1>Fridge inventory that cooks itself down.</h1>
        </div>
        <div className="status-pill">{inventory.data?.length ?? 0} items</div>
      </header>

      <section className="summary-strip" aria-label="Fridge summary">
        <Stat label="Expiring soon" value={expiringCount.toString()} tone="warm" />
        <Stat label="Suggestions" value={(suggestions.data?.length ?? 0).toString()} tone="cool" />
        <Stat label="Cooked" value={(sessions.data?.length ?? 0).toString()} tone="fresh" />
      </section>

      <div className="workspace">
        <section className="panel inventory-panel">
          <div className="panel-heading">
            <h2>Inventory</h2>
          </div>

          <form className="item-form" onSubmit={submitInventory}>
            <label className="field-label field-full">
              Ingredient
              <input
                placeholder="e.g. milk"
                value={form.name}
                onChange={(event) => setForm((current) => ({ ...current, name: event.target.value }))}
                required
              />
            </label>
            <div className="field-row quantity-unit-row">
              <div className="field-label quantity-field">
                <span>Quantity</span>
                <div className="quantity-stepper">
                  <button
                    type="button"
                    className="stepper-button"
                    aria-label="Decrease quantity"
                    disabled={form.quantity <= 0}
                    onClick={() => adjustQuantity(-1)}
                  >
                    −
                  </button>
                  <input
                    id="inventory-quantity"
                    aria-label="Quantity"
                    type="number"
                    min="0"
                    step="1"
                    placeholder="1"
                    value={form.quantity}
                    onChange={(event) =>
                      setForm((current) => ({
                        ...current,
                        quantity: Math.max(0, Math.round(Number(event.target.value) || 0)),
                      }))
                    }
                    required
                  />
                  <button
                    type="button"
                    className="stepper-button"
                    aria-label="Increase quantity"
                    onClick={() => adjustQuantity(1)}
                  >
                    +
                  </button>
                </div>
              </div>
              <label className="field-label">
                Unit
                <select
                  value={form.unit}
                  onChange={(event) => setForm((current) => ({ ...current, unit: event.target.value }))}
                >
                  {units.map((unit) => (
                    <option key={unit}>{unit}</option>
                  ))}
                </select>
              </label>
            </div>
            <label className="field-label field-full">
              Expiry date
              <input
                type="date"
                value={form.expiryDate ?? ''}
                onChange={(event) => setForm((current) => ({ ...current, expiryDate: event.target.value || null }))}
              />
            </label>
            <div className="add-actions-row field-full">
              <button className="primary-action add-submit" type="submit" disabled={createItem.isLoading}>
                <Plus size={18} />
                Add
              </button>
              <button
                type="button"
                className="camera-demo-button"
                title="Try fridge photo demo (sample image)"
                aria-label="Try fridge photo demo (sample image, not a real scan)"
                onClick={() => setFridgePhotoOpen(true)}
              >
                <Camera size={20} />
                <span className="demo-badge">Demo</span>
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
                <button className="icon-button" onClick={() => deleteItem.mutate(item.id)} aria-label={`Delete ${item.name}`}>
                  <Trash2 size={18} />
                </button>
              </article>
            ))}
            {inventory.data?.length === 0 ? <EmptyState text="Add ingredients to unlock recipe suggestions." /> : null}
          </div>
        </section>

        <section className="panel recipe-panel">
          <div className="panel-heading">
            <h2>Recipe Suggestions</h2>
          </div>
          <div className="recipe-list">
            {suggestions.data?.map((recipe) => (
              <RecipeCard
                key={recipe.id}
                recipe={recipe}
                isAccepting={acceptRecipe.isLoading}
                onAccept={(recipeId, servingMultiplier) => acceptRecipe.mutate({ recipeId, servingMultiplier })}
              />
            ))}
          </div>
        </section>
      </div>

      {fridgePhotoOpen ? (
        <FridgePhotoMockupOverlay
          units={units}
          onClose={() => setFridgePhotoOpen(false)}
          onSaved={invalidateV1}
          postItem={(input) => api.post<InventoryItem>('/api/inventory', input)}
        />
      ) : null}

      {createItem.error || acceptRecipe.error ? (
        <div className="toast" role="alert">{((createItem.error ?? acceptRecipe.error) as Error).message}</div>
      ) : null}
    </main>
  );
}

function Stat({ label, value, tone }: { label: string; value: string; tone: 'warm' | 'cool' | 'fresh' }) {
  return (
    <div className={`stat ${tone}`}>
      <span>{label}</span>
      <strong>{value}</strong>
    </div>
  );
}

function EmptyState({ text }: { text: string }) {
  return <p className="empty-state">{text}</p>;
}
