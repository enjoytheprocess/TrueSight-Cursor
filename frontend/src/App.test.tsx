import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { App } from './App';
import { CLIENT_USER_ID_STORAGE_KEY, DEMO_USER_ID } from './api/userId';
import { InventoryItem } from './features/inventory/types';
import { RecipeSession, RecipeSuggestion } from './features/recipes/types';

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
        optional: false,
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
        optional: false,
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

const sessions: RecipeSession[] = [];

const getMock = vi.fn(async (path: string) => {
  if (path === '/api/inventory') {
    return inventory;
  }
  if (path === '/api/recipes/suggestions') {
    return suggestions;
  }
  if (path === '/api/recipe-sessions') {
    return sessions;
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

  it('shows the demo login screen before Enter Demo', () => {
    localStorage.clear();
    renderApp();

    expect(screen.getByRole('button', { name: 'Enter Demo' })).toBeInTheDocument();
    expect(screen.getByText('Welcome to the Demo')).toBeInTheDocument();
    expect(screen.queryByText('Fridge inventory that cooks itself down.')).not.toBeInTheDocument();
  });

  it('enters demo and renders the main app', async () => {
    localStorage.clear();
    const user = userEvent.setup();
    renderApp();

    await user.click(screen.getByRole('button', { name: 'Enter Demo' }));

    expect(await screen.findByText('Fridge inventory that cooks itself down.')).toBeInTheDocument();
  });

  it('renders inventory and recipe suggestions from the API', async () => {
    renderApp();

    expect(await screen.findByRole('heading', { name: 'Eggs' })).toBeInTheDocument();
    expect(screen.getByRole('heading', { name: 'Vegetable Omelette' })).toBeInTheDocument();
    expect(screen.getByText('1 items')).toBeInTheDocument();
    expect(screen.getByText('Ready')).toBeInTheDocument();
    expect(screen.getByText('2 missing')).toBeInTheDocument();
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

    const nameInput = screen.getAllByLabelText('Ingredient name')[0];
    await user.clear(nameInput);
    await user.type(nameInput, 'Milk');
    await user.clear(screen.getAllByLabelText('Quantity')[0]);
    await user.type(screen.getAllByLabelText('Quantity')[0], '1');
    await user.selectOptions(screen.getAllByLabelText('Unit')[0], 'l');
    await user.click(screen.getAllByRole('button', { name: 'Add' })[0]);

    await waitFor(() => {
      expect(postMock).toHaveBeenCalledWith('/api/inventory', {
        name: 'Milk',
        quantity: 1,
        unit: 'l',
        expiryDate: null,
      });
    });
  });

  it('disables cook action when ingredients are missing', async () => {
    renderApp();
    await screen.findByRole('heading', { name: 'Chicken Spinach Scramble' });

    const cookButtons = screen.getAllByRole('button', { name: 'Cook and deduct' });

    expect(cookButtons[0]).toBeEnabled();
    expect(cookButtons[1]).toBeDisabled();
  });
});
