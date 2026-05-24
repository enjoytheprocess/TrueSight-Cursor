import { PointerEvent, ReactNode, useRef } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const SWIPE_MIN_PX = 48;

type RecipePagerProps = {
  index: number;
  total: number;
  onIndexChange: (index: number) => void;
  title?: string;
  children: ReactNode;
};

export function RecipePager({
  index,
  total,
  onIndexChange,
  title = 'Suggested Recipe',
  children,
}: RecipePagerProps) {
  const swipeStart = useRef<{ x: number; y: number } | null>(null);

  const canGoPrev = index > 0;
  const canGoNext = index < total - 1;
  const showArrows = total > 1;

  const goPrev = () => {
    if (canGoPrev) {
      onIndexChange(index - 1);
    }
  };

  const goNext = () => {
    if (canGoNext) {
      onIndexChange(index + 1);
    }
  };

  const clearSwipe = () => {
    swipeStart.current = null;
  };

  const onPointerDown = (event: PointerEvent<HTMLDivElement>) => {
    if (!showArrows) {
      return;
    }

    if (event.pointerType === 'mouse' && event.button !== 0) {
      return;
    }

    swipeStart.current = { x: event.clientX, y: event.clientY };
  };

  const onPointerUp = (event: PointerEvent<HTMLDivElement>) => {
    if (!swipeStart.current || !showArrows) {
      return;
    }

    const deltaX = event.clientX - swipeStart.current.x;
    const deltaY = event.clientY - swipeStart.current.y;
    clearSwipe();

    if (Math.abs(deltaX) < SWIPE_MIN_PX || Math.abs(deltaX) < Math.abs(deltaY)) {
      return;
    }

    if (deltaX > 0) {
      goPrev();
    } else {
      goNext();
    }
  };

  return (
    <div className="recipe-pager-wrap">
      <header className="recipe-pager-header">
        <div className="recipe-pager-nav-row">
          {showArrows ? (
            <PagerArrow direction="prev" disabled={!canGoPrev} onClick={goPrev} />
          ) : (
            <span className="recipe-pager-spacer" aria-hidden />
          )}
          <h2>{title}</h2>
          {showArrows ? (
            <PagerArrow direction="next" disabled={!canGoNext} onClick={goNext} />
          ) : (
            <span className="recipe-pager-spacer" aria-hidden />
          )}
        </div>
        <p className="recipe-pager-position" aria-live="polite">
          ({index + 1}/{total})
        </p>
      </header>

      <div
        className="recipe-pager-body"
        onPointerDown={onPointerDown}
        onPointerUp={onPointerUp}
        onPointerCancel={clearSwipe}
        onPointerLeave={clearSwipe}
      >
        {children}
      </div>
    </div>
  );
}

function PagerArrow({
  direction,
  disabled,
  onClick,
}: {
  direction: 'prev' | 'next';
  disabled: boolean;
  onClick: () => void;
}) {
  const label = direction === 'prev' ? 'Previous recipe' : 'Next recipe';
  const Icon = direction === 'prev' ? ChevronLeft : ChevronRight;

  return (
    <button type="button" className="pager-button" aria-label={label} disabled={disabled} onClick={onClick}>
      <Icon size={20} />
    </button>
  );
}
