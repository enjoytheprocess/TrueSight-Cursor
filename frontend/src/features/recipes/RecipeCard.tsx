import { useState } from 'react';
import { Check, Clock, ShoppingCart } from 'lucide-react';
import { formatQuantity } from '../inventory/formatting';
import {
  canCookAtServings,
  ingredientGapQuantity,
  isIngredientShort,
  scaledRequiredQuantity,
  servingMultiplierFor,
} from './recipeScaling';
import { RecipeSuggestion } from './types';

type RecipeCardProps = {
  recipe: RecipeSuggestion;
  isAccepting: boolean;
  isAddingToList?: boolean;
  onAccept: (recipeId: string, servingMultiplier: number) => void;
  onAddToList?: (payload: { name: string; quantity: number; unit: string; sourceRecipeId?: string }) => void;
};

export function RecipeCard({ recipe, isAccepting, isAddingToList = false, onAccept, onAddToList }: RecipeCardProps) {
  const [selectedServings, setSelectedServings] = useState(recipe.servings);
  const servingMultiplier = servingMultiplierFor(recipe, selectedServings);
  const canCook = canCookAtServings(recipe, servingMultiplier);
  const shortLines = recipe.ingredients.filter((line) => isIngredientShort(line, servingMultiplier));

  const changeServings = (value: number) => {
    const min = recipe.servings;
    const max = recipe.servings * 12;
    const stepped = Math.round(value / recipe.servings) * recipe.servings;
    setSelectedServings(Math.max(min, Math.min(max, stepped)));
  };

  const minServings = recipe.servings;
  const maxServings = recipe.servings * 12;

  const adjustServings = (delta: number) => {
    changeServings(selectedServings + delta * recipe.servings);
  };

  const addLineToList = (name: string, quantity: number, unit: string) => {
    onAddToList?.({ name, quantity, unit, sourceRecipeId: recipe.id });
  };

  const addAllMissing = () => {
    for (const line of shortLines) {
      const gap = ingredientGapQuantity(line, servingMultiplier);
      if (gap > 0) {
        addLineToList(line.name, gap, line.unit);
      }
    }
  };

  return (
    <article className="recipe-card">
      <div className="recipe-card-header">
        <div>
          <h3>{recipe.name}</h3>
          <p>{recipe.description}</p>
        </div>
        {canCook ? <span className="match-badge ready">Ready</span> : null}
      </div>
      <div className="recipe-meta">
        <span>
          <Clock size={16} />
          {recipe.estimatedMinutes} min
        </span>
        <span>{recipe.cuisineType}</span>
      </div>
      <div className="field-label servings-label">
        <span>Servings</span>
        <div className="quantity-stepper">
          <button
            type="button"
            className="stepper-button"
            aria-label="Decrease servings"
            disabled={selectedServings <= minServings}
            onClick={() => adjustServings(-1)}
          >
            −
          </button>
          <input
            id={`servings-${recipe.id}`}
            aria-label="Servings"
            type="number"
            min={minServings}
            max={maxServings}
            step={recipe.servings}
            value={selectedServings}
            onChange={(event) => changeServings(Number(event.target.value))}
          />
          <button
            type="button"
            className="stepper-button"
            aria-label="Increase servings"
            disabled={selectedServings >= maxServings}
            onClick={() => adjustServings(1)}
          >
            +
          </button>
        </div>
      </div>
      <div className="ingredient-table-wrap">
        <table className="ingredient-table">
          <thead>
            <tr>
              <th scope="col">Ingredient</th>
              <th scope="col">Required amount</th>
              <th scope="col" className="stock-col-header">
                <div className="stock-col-header-inner">
                  <span>Amount in stock</span>
                  {!canCook && onAddToList && shortLines.length > 0 ? (
                    <button
                      type="button"
                      className="add-all-cart"
                      disabled={isAddingToList}
                      aria-label="Add all missing ingredients to shopping list"
                      onClick={addAllMissing}
                    >
                      <span className="add-all-cart-label">ALL</span>
                      <ShoppingCart size={16} aria-hidden />
                    </button>
                  ) : null}
                </div>
              </th>
            </tr>
          </thead>
          <tbody>
            {recipe.ingredients.map((line) => {
              const required = scaledRequiredQuantity(line, servingMultiplier);
              const short = isIngredientShort(line, servingMultiplier);
              const gap = ingredientGapQuantity(line, servingMultiplier);
              return (
                <tr className={short ? 'ingredient-short' : undefined} key={`${recipe.id}-${line.name}`}>
                  <td>{line.name}</td>
                  <td>
                    {formatQuantity(required)} {line.unit}
                  </td>
                  <td className="stock-cell">
                    <span>
                      {formatQuantity(line.inStockQuantity)} {line.unit}
                    </span>
                    {onAddToList && short && gap > 0 ? (
                      <button
                        type="button"
                        className="icon-button add-to-cart-button"
                        disabled={isAddingToList}
                        aria-label={`Add ${line.name} to shopping list`}
                        onClick={() => addLineToList(line.name, gap, line.unit)}
                      >
                        <ShoppingCart size={18} />
                      </button>
                    ) : null}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
      <button
        className="cook-action"
        disabled={isAccepting || !canCook}
        onClick={() => onAccept(recipe.id, servingMultiplier)}
      >
        <Check size={18} />
        Cook and deduct
      </button>
    </article>
  );
}
