export type DetectionConfidence = 'high' | 'medium' | 'low';

export type DetectedItemDraft = {
  id: string;
  name: string;
  quantity: number;
  unit: string;
  expiryDate: string | null;
  confidence: DetectionConfidence;
  included: boolean;
};

export type FridgePhotoMockupStep = 'camera' | 'scanning' | 'review';
