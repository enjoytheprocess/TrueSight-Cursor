import { useEffect, useState } from 'react';
import { ArrowLeft, Loader2 } from 'lucide-react';
import { DemoBanner } from '../fridge-photo/DemoBanner';
import { ShoppingListInput } from '../shopping-list/types';
import { canSaveDetections, saveDetectedShoppingItems } from './saveDetectedItems';
import { createShoppingStubDetections, PRESET_SHOPPING_PHOTO_SRC } from './stubDetections';
import { DetectedItemDraft, ShoppingPhotoMockupStep } from './types';

const SCAN_DELAY_MS = 1500;

type ShoppingPhotoMockupOverlayProps = {
  units: string[];
  onClose: () => void;
  onSaved: () => Promise<void>;
  postItem: (input: ShoppingListInput) => Promise<unknown>;
};

export function ShoppingPhotoMockupOverlay({ units, onClose, onSaved, postItem }: ShoppingPhotoMockupOverlayProps) {
  const [step, setStep] = useState<ShoppingPhotoMockupStep>('camera');
  const [rows, setRows] = useState<DetectedItemDraft[]>([]);
  const [isSaving, setIsSaving] = useState(false);
  const [saveError, setSaveError] = useState<string | null>(null);

  useEffect(() => {
    if (step !== 'scanning') {
      return;
    }

    const timer = window.setTimeout(() => {
      setRows(createShoppingStubDetections());
      setStep('review');
    }, SCAN_DELAY_MS);

    return () => window.clearTimeout(timer);
  }, [step]);

  const startScan = () => {
    setSaveError(null);
    setStep('scanning');
  };

  const updateRow = (id: string, patch: Partial<DetectedItemDraft>) => {
    setRows((current) => current.map((row) => (row.id === id ? { ...row, ...patch } : row)));
  };

  const adjustRowQuantity = (id: string, delta: number) => {
    setRows((current) =>
      current.map((row) =>
        row.id === id
          ? { ...row, quantity: Math.max(0, Math.round(row.quantity) + delta) }
          : row,
      ),
    );
  };

  const handleSave = async () => {
    if (!canSaveDetections(rows) || isSaving) {
      return;
    }

    setIsSaving(true);
    setSaveError(null);

    try {
      await saveDetectedShoppingItems(rows, postItem);
      await onSaved();
      onClose();
    } catch (error) {
      setSaveError(error instanceof Error ? error.message : 'Could not save items. Try again.');
    } finally {
      setIsSaving(false);
    }
  };

  const saveDisabled = !canSaveDetections(rows) || isSaving;

  return (
    <div className="fridge-overlay" role="dialog" aria-modal="true" aria-labelledby="shopping-overlay-title">
      <header className="fridge-overlay-header">
        <button
          type="button"
          className="fridge-overlay-back"
          aria-label="Close shopping photo preview"
          onClick={onClose}
        >
          <ArrowLeft size={18} />
        </button>
        <h2 id="shopping-overlay-title">Shopping photo preview</h2>
      </header>

      <DemoBanner />

      {step === 'camera' ? (
        <div className="fridge-overlay-body">
          <img
            className="fridge-preset-photo"
            src={PRESET_SHOPPING_PHOTO_SRC}
            alt="Sample product packaging used for demo shopping list scan"
          />
          <p className="fridge-overlay-helper">Uses a fixed sample image to preview the flow.</p>
          <button type="button" className="primary-action fridge-overlay-primary" onClick={startScan}>
            Use sample photo
          </button>
        </div>
      ) : null}

      {step === 'scanning' ? (
        <div className="fridge-overlay-body fridge-overlay-center">
          <Loader2 className="fridge-scan-spinner" size={32} aria-hidden />
          <p>Scanning sample photo…</p>
        </div>
      ) : null}

      {step === 'review' ? (
        <div className="fridge-overlay-review-layout">
          <div className="fridge-overlay-scroll">
            <div className="fridge-review-intro">
              <h3>Suggested items (preview)</h3>
              <p>Edit names, quantities, and units, then save to your shopping list.</p>
              <p className="fridge-review-footnote">Confidence shown for preview only.</p>
            </div>

            <ul className="fridge-review-list">
              {rows.map((row) => (
                <li key={row.id} className="fridge-review-row">
                  <div className="fridge-review-head">
                    <label className="fridge-review-include">
                      <input
                        type="checkbox"
                        checked={row.included}
                        aria-label={`Include ${row.name}`}
                        onChange={(event) => updateRow(row.id, { included: event.target.checked })}
                      />
                    </label>
                    <input
                      className="fridge-review-name-input"
                      aria-label="Ingredient name"
                      value={row.name}
                      onChange={(event) => updateRow(row.id, { name: event.target.value })}
                    />
                    <span className={`confidence-badge confidence-${row.confidence}`}>{row.confidence}</span>
                  </div>

                  <div className="field-row quantity-unit-row fridge-review-quantity-unit">
                    <div className="field-label quantity-field">
                      <span>Quantity</span>
                      <div className="quantity-stepper">
                        <button
                          type="button"
                          className="stepper-button"
                          aria-label={`Decrease ${row.name} quantity`}
                          disabled={row.quantity <= 0}
                          onClick={() => adjustRowQuantity(row.id, -1)}
                        >
                          −
                        </button>
                        <input
                          aria-label={`${row.name} quantity`}
                          type="number"
                          min="0"
                          step="1"
                          value={row.quantity}
                          onChange={(event) =>
                            updateRow(row.id, {
                              quantity: Math.max(0, Math.round(Number(event.target.value) || 0)),
                            })
                          }
                        />
                        <button
                          type="button"
                          className="stepper-button"
                          aria-label={`Increase ${row.name} quantity`}
                          onClick={() => adjustRowQuantity(row.id, 1)}
                        >
                          +
                        </button>
                      </div>
                    </div>

                    <label className="field-label">
                      Unit
                      <select
                        value={row.unit}
                        onChange={(event) => updateRow(row.id, { unit: event.target.value })}
                      >
                        {units.map((unit) => (
                          <option key={unit}>{unit}</option>
                        ))}
                      </select>
                    </label>
                  </div>
                </li>
              ))}
            </ul>

            {saveError ? (
              <p className="fridge-save-error" role="alert">
                {saveError}
              </p>
            ) : null}
          </div>

          <footer className="fridge-overlay-footer">
            <div className="fridge-overlay-actions">
              <button type="button" className="secondary-action" onClick={onClose} disabled={isSaving}>
                Cancel
              </button>
              <button
                type="button"
                className="primary-action"
                disabled={saveDisabled}
                onClick={() => void handleSave()}
              >
                {isSaving ? 'Saving…' : 'Save to shopping list'}
              </button>
            </div>
          </footer>
        </div>
      ) : null}
    </div>
  );
}
