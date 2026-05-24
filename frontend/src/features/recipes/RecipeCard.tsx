import { useState } from 'react';
import { Check, Clock } from 'lucide-react';
import { formatQuantity } from '../inventory/formatting';
import { canCookAtServings, isIngredientShort, scaledRequiredQuantity, servingMultiplierFor } from './recipeScaling';
import { RecipeSuggestion } from './types';

type RecipeCardProps = {
  recipe: RecipeSuggestion;
  isAccepting: boolean;
  onAccept: (recipeId: string, servingMultiplier: number) => void;
};

export function RecipeCard({ recipe, isAccepting, onAccept }: RecipeCardProps) {
  const [selectedServings, setSelectedServings] = useState(recipe.servings);
  const servingMultiplier = servingMultiplierFor(recipe, selectedServings);
  const canCook = canCookAtServings(recipe, servingMultiplier);

  const changeServings = (value: number) => {
    const min = recipe.servings;
    const max = recipe.servings * 12;
    const stepped = Math.round(value / recipe.servings) * recipe.servings;
    setSelectedServings(Math.max(min, Math.min(max, stepped)));
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
      <label className="field-label servings-label" htmlFor={`servings-${recipe.id}`}>
        Servings
        <input
          id={`servings-${recipe.id}`}
          type="number"
          min={recipe.servings}
          max={recipe.servings * 12}
          step={recipe.servings}
          value={selectedServings}
          onChange={(event) => changeServings(Number(event.target.value))}
        />
      </label>
      <div className="ingredient-table-wrap">
        <table className="ingredient-table">
          <thead>
            <tr>
              <th scope="col">Ingredient</th>
              <th scope="col">Required amount</th>
              <th scope="col">Amount in stock</th>
            </tr>
          </thead>
          <tbody>
            {recipe.ingredients.map((line) => {
              const required = scaledRequiredQuantity(line, servingMultiplier);
              const short = isIngredientShort(line, servingMultiplier);
              return (
                <tr className={short ? 'ingredient-short' : undefined} key={`${recipe.id}-${line.name}`}>
                  <td>{line.name}</td>
                  <td>
                    {formatQuantity(required)} {line.unit}
                  </td>
                  <td>
                    {formatQuantity(line.inStockQuantity)} {line.unit}
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
