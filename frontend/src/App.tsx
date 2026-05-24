import { FormEvent, useMemo, useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Check, Clock, Plus, Trash2 } from 'lucide-react';
import { api } from './api/client';
import { formatDate, formatQuantity, isExpiringSoon } from './features/inventory/formatting';
import { InventoryInput, InventoryItem } from './features/inventory/types';
import { RecipeSession, RecipeSuggestion } from './features/recipes/types';

const units = ['count', 'g', 'kg', 'ml', 'l', 'oz', 'lb', 'cup', 'tbsp', 'tsp'];

export function App() {
  const queryClient = useQueryClient();
  const [form, setForm] = useState<InventoryInput>({ name: '', quantity: 1, unit: 'count', expiryDate: null });

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
    mutationFn: (recipeId: string) => api.post<RecipeSession>('/api/recipe-sessions', { recipeId, servingMultiplier: 1 }),
    onSuccess: invalidateV1,
  });

  const expiringCount = useMemo(() => {
    const today = new Date();
    const soon = new Date();
    soon.setDate(today.getDate() + 3);
    return inventory.data?.filter((item) => item.expiryDate && new Date(`${item.expiryDate}T00:00:00`) <= soon).length ?? 0;
  }, [inventory.data]);

  const submitInventory = (event: FormEvent) => {
    event.preventDefault();
    createItem.mutate({
      ...form,
      name: form.name.trim(),
      quantity: Number(form.quantity),
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
            <input
              aria-label="Ingredient name"
              placeholder="Ingredient"
              value={form.name}
              onChange={(event) => setForm((current) => ({ ...current, name: event.target.value }))}
              required
            />
            <input
              aria-label="Quantity"
              type="number"
              min="0"
              step="0.01"
              value={form.quantity}
              onChange={(event) => setForm((current) => ({ ...current, quantity: Number(event.target.value) }))}
              required
            />
            <select
              aria-label="Unit"
              value={form.unit}
              onChange={(event) => setForm((current) => ({ ...current, unit: event.target.value }))}
            >
              {units.map((unit) => (
                <option key={unit}>{unit}</option>
              ))}
            </select>
            <input
              aria-label="Expiry date"
              type="date"
              value={form.expiryDate ?? ''}
              onChange={(event) => setForm((current) => ({ ...current, expiryDate: event.target.value || null }))}
            />
            <button className="primary-action" type="submit" disabled={createItem.isLoading}>
              <Plus size={18} />
              Add
            </button>
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
              <article className="recipe-card" key={recipe.id}>
                <div className="recipe-card-header">
                  <div>
                    <h3>{recipe.name}</h3>
                    <p>{recipe.description}</p>
                  </div>
                  <span className={recipe.missingIngredientCount === 0 ? 'match-badge ready' : 'match-badge'}>
                    {recipe.missingIngredientCount === 0 ? 'Ready' : `${recipe.missingIngredientCount} missing`}
                  </span>
                </div>
                <div className="recipe-meta">
                  <span>
                    <Clock size={16} />
                    {recipe.estimatedMinutes} min
                  </span>
                  <span>{recipe.cuisineType}</span>
                  <span>{recipe.ownedIngredientCount} owned</span>
                </div>
                <div className="ingredient-row">
                  {recipe.usesIngredients.map((ingredient) => (
                    <span className="ingredient-chip" key={ingredient}>{ingredient}</span>
                  ))}
                </div>
                <button
                  className="cook-action"
                  disabled={acceptRecipe.isLoading || recipe.missingIngredientCount > 0}
                  onClick={() => acceptRecipe.mutate(recipe.id)}
                >
                  <Check size={18} />
                  Cook and deduct
                </button>
              </article>
            ))}
          </div>
        </section>
      </div>

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
