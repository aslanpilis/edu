import React, { useEffect } from 'react';
import confetti from 'canvas-confetti';
import { Award, Sparkles, X } from 'lucide-react';
import { Achievement } from '../../types/progress';
import { audioService } from '../../services/audioService';

interface BadgeNotificationProps {
  badge: Achievement | null;
  onDismiss: () => void;
}

export const BadgeNotification: React.FC<BadgeNotificationProps> = ({ badge, onDismiss }) => {
  useEffect(() => {
    if (badge) {
      audioService.playStarEarned(2);
      try {
        confetti({
          particleCount: 80,
          spread: 70,
          origin: { y: 0.2 },
        });
      } catch (e) {}
    }
  }, [badge]);

  if (!badge) return null;

  return (
    <div className="fixed top-6 right-6 z-50 animate-bounce duration-1000 max-w-sm w-full">
      <div className="bg-gradient-to-r from-amber-400 via-yellow-300 to-amber-500 rounded-3xl p-5 shadow-2xl border-4 border-white flex items-center gap-4 text-amber-950 relative">
        <button
          onClick={onDismiss}
          className="absolute top-2 right-2 p-1 rounded-full text-amber-800 hover:bg-black/10 transition"
        >
          <X className="w-4 h-4" />
        </button>

        <div className="text-4xl bg-white/80 p-3 rounded-2xl shadow-inner border border-amber-200">
          {badge.icon || '🏆'}
        </div>

        <div className="flex-1">
          <div className="flex items-center gap-1 text-xs font-black uppercase tracking-wider text-amber-800">
            <Sparkles className="w-3.5 h-3.5" /> Yeni Rozet Açıldı!
          </div>
          <h4 className="text-lg font-black text-amber-950 leading-tight">
            {badge.title}
          </h4>
          <p className="text-xs text-amber-900 mt-0.5 font-medium">
            {badge.description}
          </p>
        </div>
      </div>
    </div>
  );
};
