import React, { useState, useEffect } from 'react';
import { Lock, X, Check } from 'lucide-react';
import { audioService } from '../../services/audioService';

interface ParentalGateModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export const ParentalGateModal: React.FC<ParentalGateModalProps> = ({
  isOpen,
  onClose,
  onSuccess,
}) => {
  const [num1, setNum1] = useState(0);
  const [num2, setNum2] = useState(0);
  const [userAnswer, setUserAnswer] = useState('');
  const [error, setError] = useState(false);

  useEffect(() => {
    if (isOpen) {
      const n1 = Math.floor(Math.random() * 6) + 4; // 4 - 9
      const n2 = Math.floor(Math.random() * 6) + 3; // 3 - 8
      setNum1(n1);
      setNum2(n2);
      setUserAnswer('');
      setError(false);
    }
  }, [isOpen]);

  if (!isOpen) return null;

  const correctAnswer = num1 * num2;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (parseInt(userAnswer, 10) === correctAnswer) {
      audioService.playSuccess();
      onSuccess();
      onClose();
    } else {
      setError(true);
      audioService.playTryAgain();
      setUserAnswer('');
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 animate-in fade-in duration-200">
      <div className="bg-white rounded-3xl p-6 sm:p-8 max-w-md w-full shadow-2xl border-4 border-amber-300 relative text-center">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-2 text-gray-400 hover:text-gray-600 rounded-full hover:bg-gray-100 transition"
        >
          <X className="w-6 h-6" />
        </button>

        <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mx-auto mb-4 border-2 border-amber-300">
          <Lock className="w-8 h-8 text-amber-600" />
        </div>

        <h3 className="text-xl font-bold text-gray-800 mb-1">Ebeveyn Girişi</h3>
        <p className="text-sm text-gray-500 mb-6">
          Ebeveyn paneline geçmek için lütfen aşağıdaki matematik işlemini çözünüz (Çocuk koruma kilidi).
        </p>

        <div className="bg-amber-50 rounded-2xl p-4 mb-6 border border-amber-200">
          <span className="text-3xl font-extrabold text-amber-800">
            {num1} × {num2} = ?
          </span>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <input
            type="number"
            value={userAnswer}
            onChange={(e) => {
              setUserAnswer(e.target.value);
              setError(false);
            }}
            placeholder="Cevabınız"
            autoFocus
            className={`w-full text-center text-2xl font-bold py-3 px-4 rounded-xl border-2 focus:outline-none transition ${
              error
                ? 'border-rose-400 bg-rose-50 text-rose-700'
                : 'border-gray-200 focus:border-amber-500 bg-gray-50'
            }`}
          />

          {error && (
            <p className="text-sm text-rose-500 font-medium">
              Hatalı cevap, lütfen tekrar deneyin!
            </p>
          )}

          <div className="flex gap-3">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 py-3 px-4 rounded-xl font-semibold text-gray-600 bg-gray-100 hover:bg-gray-200 transition"
            >
              Vazgeç
            </button>
            <button
              type="submit"
              disabled={!userAnswer}
              className="flex-1 py-3 px-4 rounded-xl font-bold text-white bg-amber-500 hover:bg-amber-600 disabled:opacity-50 shadow-md hover:shadow-lg transition flex items-center justify-center gap-2"
            >
              <Check className="w-5 h-5" /> Doğrula
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
