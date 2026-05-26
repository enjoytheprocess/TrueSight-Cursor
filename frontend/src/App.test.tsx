import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { App } from './App';
import { CLIENT_USER_ID_STORAGE_KEY, DEMO_USER_ID } from './api/userId';
import { InventoryItem } from './features/inventory/types';
import { RecipeSuggestion } from './features/recipes/types';
import { ShoppingListItem } from './features/shopping-list/types';

const inventory: InventoryItem[] = [
  {
    id: 'item-1',
    name: 'Eggs',
    quantity: 2,
    unit: 'count',
    expiryDate: '2026-05-26',
    addedAt: '2026-05-01T00:00:00Z',
    updatedAt: '2026-05-01T00:00:00Z',
  },
];

const shoppingList: ShoppingListItem[] = [];

const suggestions: RecipeSuggestion[] = [
  {
    id: 'vegetable-omelette',
    name: 'Vegetable Omelette',
    description: 'Flexible breakfast-for-dinner option.',
    cuisineType: 'Everyday',
    difficulty: 'Easy',
    estimatedMinutes: 15,
    servings: 1,
    canCook: true,
    ingredients: [
      {
        name: 'eggs',
        requiredQuantity: 2,
        unit: 'count',
        inStockQuantity: 4,
        status: 'sufficient',
      },
    ],
    missingIngredientCount: 0,
    ownedIngredientCount: 1,
    expiringSoonIngredientCount: 0,
    score: 10,
    usesIngredients: ['eggs'],
    missingIngredients: [],
  },
  {
    id: 'chicken-spinach-eggs',
    name: 'Chicken Spinach Scramble',
    description: 'Needs more ingredients.',
    cuisineType: 'Everyday',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    servings: 2,
    canCook: false,
    ingredients: [
      {
        name: 'chicken',
        requiredQuantity: 300,
        unit: 'g',
        inStockQuantity: 0,
        status: 'missing',
      },
    ],
    missingIngredientCount: 2,
    ownedIngredientCount: 1,
    expiringSoonIngredientCount: 0,
    score: 5,
    usesIngredients: ['chicken', 'spinach', 'eggs'],
    missingIngredients: ['chicken', 'spinach'],
  },
];

const getMock = vi.fn(async (path: string) => {
  if (path === '/api/inventory') {
    return inventory;
  }
  if (path === '/api/shopping-list') {
    return shoppingList;
  }
  if (path === '/api/recipes/suggestions') {
    return suggestions;
  }
  throw new Error(`Unexpected GET ${path}`);
});

const postMock = vi.fn();
const deleteMock = vi.fn();

vi.mock('./api/client', () => ({
  api: {
    get: (path: string) => getMock(path),
    post: (...args: unknown[]) => postMock(...args),
    put: vi.fn(),
    delete: (...args: unknown[]) => deleteMock(...args),
  },
}));

function renderApp() {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
      mutations: { retry: false },
    },
  });

  return render(
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>,
  );
}

describe('App', () => {
  beforeEach(() => {
    localStorage.setItem(CLIENT_USER_ID_STORAGE_KEY, DEMO_USER_ID);
    getMock.mockClear();
    postMock.mockClear();
    deleteMock.mockClear();
  });

  it('renders the main app on cold start without a login screen', async () => {
    localStorage.clear();
    renderApp();

    expect(screen.queryByRole('button', { name: 'Enter Demo' })).not.toBeInTheDocument();
    expect(await screen.findByText('Fridge inventory that cooks itself down.')).toBeInTheDocument();
  });

  it('renders inventory and recipe pager from the API', async () => {
    renderApp();

    expect(await screen.findByRole('heading', { name: 'Eggs' })).toBeInTheDocument();
    expect(screen.getByRole('heading', { name: 'Vegetable Omelette' })).toBeInTheDocument();
    expect(screen.getByText('1 in stock')).toBeInTheDocument();
    expect(screen.getByText('(1/2)')).toBeInTheDocument();
    expect(screen.getByText('Ready')).toBeInTheDocument();
    expect(screen.queryByRole('heading', { name: 'Chicken Spinach Scramble' })).not.toBeInTheDocument();
  });

  it('submits a new inventory item', async () => {
    const user = userEvent.setup();
    postMock.mockResolvedValueOnce({
      id: 'item-2',
      name: 'Milk',
      quantity: 1,
      unit: 'l',
      expiryDate: null,
      addedAt: '2026-05-24T00:00:00Z',
      updatedAt: '2026-05-24T00:00:00Z',
    });

    renderApp();
    await screen.findByRole('heading', { name: 'Eggs' });

    const nameInput = screen.getByLabelText('Ingredient');
    await user.clear(nameInput);
    await user.type(nameInput, 'Milk');
    await user.clear(screen.getByLabelText('Quantity'));
    await user.type(screen.getByLabelText('Quantity'), '1');
    await user.selectOptions(screen.getByLabelText('Unit'), 'l');
    await user.click(screen.getByRole('button', { name: 'Add' }));

    await waitFor(() => {
      expect(postMock).toHaveBeenCalledWith('/api/inventory', {
        name: 'Milk',
        quantity: 1,
        unit: 'l',
        expiryDate: null,
      });
    });
  });

  it('switches to the shopping list tab', async () => {
    const user = userEvent.setup();
    renderApp();
    await screen.findByRole('heading', { name: 'Eggs' });

    await user.click(screen.getByRole('tab', { name: 'Shopping List' }));

    expect(screen.getByRole('heading', { name: 'Shopping List' })).toBeInTheDocument();
    expect(screen.getByText('Shopping List that stock your fridge up')).toBeInTheDocument();
    expect(screen.queryByText('Fridge inventory that cooks itself down.')).not.toBeInTheDocument();
    expect(screen.getByText('0 to buy')).toBeInTheDocument();
    expect(screen.queryByLabelText('Expiry date')).not.toBeInTheDocument();
  });

  it('opens the shopping photo preview overlay', async () => {
    const user = userEvent.setup();
    renderApp();
    await screen.findByRole('heading', { name: 'Eggs' });

    await user.click(screen.getByRole('tab', { name: 'Shopping List' }));
    await user.click(screen.getByRole('button', { name: /Try shopping photo preview/i }));

    expect(screen.getByRole('dialog')).toBeInTheDocument();
    expect(screen.getByText(/Preview — sample photo/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Use sample photo' })).toBeInTheDocument();
    expect(screen.getByAltText(/Sample product packaging/i)).toHaveAttribute('src', '/mockups/shopping-preset.png');
  });

  it('opens the fridge photo preview overlay', async () => {
    const user = userEvent.setup();
    renderApp();
    await screen.findByRole('heading', { name: 'Eggs' });

    await user.click(screen.getByRole('button', { name: /Try fridge photo preview/i }));

    expect(screen.getByRole('dialog')).toBeInTheDocument();
    expect(screen.getByText(/Preview — sample photo/i)).toBeInTheDocument();
  });

  it('disables cook action when ingredients are missing', async () => {
    const user = userEvent.setup();
    renderApp();
    await screen.findByRole('heading', { name: 'Vegetable Omelette' });

    expect(screen.getByRole('button', { name: 'Cook and deduct' })).toBeEnabled();

    await user.click(screen.getByRole('button', { name: 'Next recipe' }));

    expect(await screen.findByRole('heading', { name: 'Chicken Spinach Scramble' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Cook and deduct' })).toBeDisabled();
    expect(screen.getByRole('button', { name: 'Add all missing ingredients to shopping list' })).toHaveTextContent('ALL');
  });

  it('keeps the shopping list tab active after confirming move to in stock', async () => {
    const user = userEvent.setup();
    const listItem: ShoppingListItem = {
      id: 'shop-1',
      name: 'Spinach',
      quantity: 2,
      unit: 'count',
      sourceRecipeId: null,
      createdAt: '2026-05-26T00:00:00Z',
    };

    getMock.mockImplementation(async (path: string) => {
      if (path === '/api/inventory') {
        return inventory;
      }
      if (path === '/api/shopping-list') {
        return [listItem];
      }
      if (path === '/api/recipes/suggestions') {
        return suggestions;
      }
      throw new Error(`Unexpected GET ${path}`);
    });

    postMock.mockResolvedValueOnce({
      id: 'item-2',
      name: 'Spinach',
      quantity: 2,
      unit: 'count',
      expiryDate: null,
      addedAt: '2026-05-26T00:00:00Z',
      updatedAt: '2026-05-26T00:00:00Z',
    });

    renderApp();
    await screen.findByRole('heading', { name: 'Eggs' });

    await user.click(screen.getByRole('tab', { name: 'Shopping List' }));
    expect(await screen.findByText('1 to buy')).toBeInTheDocument();

    await user.click(screen.getByRole('button', { name: 'Move Spinach to in stock' }));
    await user.click(screen.getByRole('button', { name: 'Confirm move Spinach to in stock' }));

    await waitFor(() => {
      expect(postMock).toHaveBeenCalledWith('/api/shopping-list/shop-1/move-to-inventory', { expiryDate: null });
    });

    expect(screen.getByRole('tab', { name: 'Shopping List' })).toHaveAttribute('aria-selected', 'true');
    expect(screen.getByText('Shopping List that stock your fridge up')).toBeInTheDocument();
  });

  it('uses a two-column shell workspace on wide viewports', () => {
    renderApp();
    expect(document.querySelector('.shell-workspace')).toBeInTheDocument();
  });
});
