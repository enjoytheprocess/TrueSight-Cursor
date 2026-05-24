import { fireEvent, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { RecipePager } from './RecipePager';

describe('RecipePager', () => {
  it('renders children without arrows when only one recipe', () => {
    render(
      <RecipePager index={0} total={1} onIndexChange={vi.fn()}>
        <p>Only recipe</p>
      </RecipePager>,
    );

    expect(screen.getByText('Only recipe')).toBeInTheDocument();
    expect(screen.getByText('(1/1)')).toBeInTheDocument();
    expect(screen.queryByRole('button', { name: 'Next recipe' })).not.toBeInTheDocument();
  });

  it('calls onIndexChange when next arrow is clicked', async () => {
    const onIndexChange = vi.fn();
    const user = userEvent.setup();

    render(
      <RecipePager index={0} total={3} onIndexChange={onIndexChange}>
        <p>Recipe A</p>
      </RecipePager>,
    );

    await user.click(screen.getByRole('button', { name: 'Next recipe' }));

    expect(onIndexChange).toHaveBeenCalledWith(1);
  });

  it('advances on horizontal swipe', () => {
    const onIndexChange = vi.fn();

    const { container } = render(
      <RecipePager index={0} total={3} onIndexChange={onIndexChange}>
        <p>Recipe A</p>
      </RecipePager>,
    );

    const body = container.querySelector('.recipe-pager-body');
    expect(body).not.toBeNull();

    fireEvent.pointerDown(body!, { clientX: 200, clientY: 100, button: 0 });
    fireEvent.pointerUp(body!, { clientX: 120, clientY: 100, button: 0 });

    expect(onIndexChange).toHaveBeenCalledWith(1);
  });
});
