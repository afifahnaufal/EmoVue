let userId = 1; // Set default user ID for testing

let emotionChartInstance = null;

function initializeApp() {
    loadWeeklyEmotions();
    initializeWeeklyReflection();
}

function initializeWeeklyReflection() {
    const reflectionBtn = document.querySelector('.reflection-btn');
    const reflectionModal = document.querySelector('.reflection-modal');
    const reflectionText = document.querySelector('.reflection-text');
    const saveReflectionBtn = document.querySelector('.save-reflection-btn');
    const closeReflectionBtn = document.querySelector('.close-reflection-btn');

    if (reflectionBtn && reflectionModal) {
        reflectionBtn.addEventListener('click', () => {
            reflectionModal.style.display = 'block';
            loadCurrentReflection();
        });

        closeReflectionBtn.addEventListener('click', () => {
            reflectionModal.style.display = 'none';
        });

        window.addEventListener('click', (e) => {
            if (e.target === reflectionModal) {
                reflectionModal.style.display = 'none';
            }
        });

        saveReflectionBtn.addEventListener('click', async () => {
            const reflectionTextValue = reflectionText.value.trim();
            if (!reflectionTextValue) {
                showEmotionAlert('Peringatan', 'Tolong isi refleksi Anda');
                return;
            }

            try {
                const response = await fetch('api/save_weekly_reflection.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        user_id: userId,
                        week_start: getWeekStartDate(),
                        reflection_text: reflectionTextValue
                    })
                });

                const data = await response.json();

                if (data.success) {
                    reflectionModal.style.display = 'none';
                    showEmotionAlert('Positif', 'Refleksi mingguan berhasil disimpan!');
                    loadWeeklyEmotions(); // Refresh data
                } else {
                    showEmotionAlert('Error', data.message || 'Gagal menyimpan refleksi');
                }
            } catch (error) {
                console.error('Error:', error);
                showEmotionAlert('Error', 'Gagal menyimpan refleksi');
            }
        });
    }
}

async function loadCurrentReflection() {
    const reflectionText = document.querySelector('.reflection-text');
    if (reflectionText) {
        try {
            const response = await fetch(`api/get_weekly_emotions.php?user_id=${userId}`);
            const data = await response.json();

            if (data.success && data.statistics) {
                reflectionText.value = data.statistics.weekly_reflection || '';
            }
        } catch (error) {
            console.error('Error:', error);
        }
    }
}

function getWeekStartDate() {
    const today = new Date();
    const day = today.getDay();
    const diff = today.getDate() - day + (day === 0 ? -6 : 1); // Adjust for Monday start
    const monday = new Date(today.setDate(diff));
    return monday.toISOString().split('T')[0];
}

async function loadWeeklyEmotions() {
    if (!userId) return;

    try {
        const response = await fetch(`api/get_weekly_emotions.php?user_id=${userId}`);
        const data = await response.json();
        if (data.success) {
            const emotions = Array.isArray(data.data) ? data.data : [];
            updateEmotionChart(emotions);
            populateMoodboard(emotions);
            updateEmotionStats(data.statistics || {});
        } else {
            showEmotionAlert('Peringatan', 'Gagal memuat emosi');
        }

    } catch (error) {
        console.error('Error:', error);
        const errorMessage = error instanceof Error ? error.message : 'Gagal memuat emosi';
        showEmotionAlert('Error', errorMessage);
    }
}

function updateEmotionChart(emotions) {
    const ctx = document.getElementById('emotionChart');

    if (emotionChartInstance) {
        emotionChartInstance.destroy();
    }

    const dates = Array.from({ length: 7 }, (_, i) => {
        const date = new Date();
        date.setDate(date.getDate() - (6 - i));
        return date.toLocaleDateString();
    });

    const emotionTypes = ['Senang', 'Marah', 'Stres', 'Sedih'];
    const colors = {
        Senang: '#4CAF50',
        Marah: '#F44336',
        Stres: '#FFC107',
        Sedih: '#2196F3'
    };

    const datasets = emotionTypes.map(type => {
        return {
            label: type.charAt(0).toUpperCase() + type.slice(1),
            data: dates.map(date =>
                emotions.filter(e => e.emotion === type && new Date(e.date).toLocaleDateString() === date).length
            ),
            borderColor: colors[type],
            backgroundColor: colors[type],
            fill: false,
            tension: 0.1
        };
    });

    emotionChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: dates,
            datasets: datasets
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' },
                title: { display: true, text: 'Weekly Emotional Activity' }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1 }
                }
            }
        }
    });
}

function populateMoodboard(emotions) {
    const moodboardContainer = document.querySelector('.mood-cards');
    moodboardContainer.innerHTML = '';

    emotions.forEach(mood => {
        const card = document.createElement('div');
        card.className = 'emotion-card';
        card.style.backgroundColor = getEmotionColor(mood.emotion);
        card.innerHTML = `
            <i class="fas fa-${getEmotionIcon(mood.emotion)}"></i>
            <div class="mood-info">
                <span class="date">${new Date(mood.date).toLocaleDateString()}</span>
                <p class="note">${mood.notes}</p>
            </div>
        `;
        moodboardContainer.appendChild(card);
    });
}

function updateEmotionStats(stats) {
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach(card => {
        const statType = card.querySelector('h3').textContent.toLowerCase();
        const value = stats[statType] || 0;
        card.querySelector('.stat-value').textContent = value;
    });
}

let selectedEmotion = null;

document.addEventListener('click', function (e) {
    if (e.target.closest('.emotion-card')) {
        document.querySelectorAll('.emotion-card').forEach(c => c.classList.remove('active'));
        const clicked = e.target.closest('.emotion-card');
        clicked.classList.add('active');
        selectedEmotion = clicked.classList.contains('happy') ? 'senang' :
                         clicked.classList.contains('neutral') ? 'netral' :
                         clicked.classList.contains('sad') ? 'sedih' :
                         'marah';
    }
});

const submitBtn = document.querySelector('.submit-btn');
const emotionForm = document.querySelector('.emotion-form');
const textarea = emotionForm.querySelector('textarea');

submitBtn.addEventListener('click', async function () {
    if (!userId) {
        showEmotionAlert('Peringatan', 'Silakan autentikasi terlebih dahulu');
        return;
    }

    const emotionText = textarea.value.trim();
    if (!emotionText) {
        showEmotionAlert('Peringatan', 'Silakan deskripsikan emosi Anda sebelum mengirim.');
        return;
    }

    if (!selectedEmotion) {
        showEmotionAlert('Peringatan', 'Silakan pilih emosi Anda terlebih dahulu.');
        return;
    }

    try {
        // Check emotion before submitting
        const emotionAnalysis = await checkEmotionOnSubmit(emotionText);
        
        // If emotion is severe negative, show the notification
        if (emotionAnalysis.hasAlert) {
            showEmotionAlert('Warning', emotionAnalysis.message, emotionAnalysis.suggestions);
        }

        const response = await fetch('api/log_emotion.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                user_id: userId,
                emotion: selectedEmotion,
                intensity: 3,
                emotion_trigger: 'Manual input',
                notes: emotionText
            })
        });

        const data = await response.json();

        if (data.success) {
            textarea.value = '';
            document.querySelectorAll('.emotion-card').forEach(card => card.classList.remove('active'));
            selectedEmotion = null;
            showEmotionAlert('Positif', 'Emosi Anda telah berhasil direkam!');
            loadWeeklyEmotions();
        } else {
            showEmotionAlert('Error', data.message || 'Gagal merekam emosi');
        }
    } catch (error) {
        // console.error('Error:', error);
        showEmotionAlert('Error', error.message || 'Gagal merekam emosi');
    }
});

function getEmotionColor(emotion) {
    const colors = {
        Senang: '#4CAF50',
        Netral: '#9E9E9E',
        Sedih: '#2196F3',
        Marah: '#F44336',
        Stres: '#FFC107'
    };
    return colors[emotion];
}

function getEmotionIcon(emotion) {
    const icons = {
        Senang: 'face-smile',
        Netral: 'face-meh',
        Sedih: 'face-sad-tear',
        Marah: 'face-angry',
        Stres: 'face-tired'
    };
    return icons[emotion];
}

function showEmotionAlert(type, message, suggestions = []) {
    // Create toast element
    const toast = document.createElement('div');
    toast.className = 'toast';

    // Add icon
    const icon = document.createElement('i');
    icon.className = `toast__icon fas ${type === 'Error' ? 'fa-exclamation-circle' : 'fa-info-circle'}`;
    
    // Add content
    const content = document.createElement('div');
    content.className = 'toast__content';
    
    // Add title and message
    const messageElement = document.createElement('div');
    messageElement.className = 'toast__message';
    messageElement.textContent = message;
    content.appendChild(messageElement);
    
    // Add suggestions if any
    if (suggestions.length > 0) {
        const suggestionsContainer = document.createElement('div');
        suggestionsContainer.className = 'toast__suggestions';
        
        suggestions.forEach(suggestion => {
            const suggestionElement = document.createElement('div');
            suggestionElement.className = 'toast__suggestion';
            suggestionElement.textContent = suggestion;
            suggestionsContainer.appendChild(suggestionElement);
        });
        
        content.appendChild(suggestionsContainer);
    }
    
    toast.appendChild(icon);
    toast.appendChild(content);
    
    // Add to container
    const toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        const container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    
    toastContainer.appendChild(toast);
    
    // Animation
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(-20px)';
    setTimeout(() => {
        toast.style.opacity = '1';
        toast.style.transform = 'translateY(0)';
    }, 100);
    
    // Remove after duration
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(-20px)';
        setTimeout(() => toast.remove(), 300);
    }, 5000);
}

document.addEventListener('DOMContentLoaded', function () {
    initializeApp();
});

// Function to check emotion when text is submitted
async function checkEmotionOnSubmit(text) {
    try {
        const response = await fetch('api/analyze_emotion.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ text })
        });
        
        const data = await response.json();
        
        if (data.hasAlert) {
            showEmotionAlert('Warning', data.message, data.suggestions);
        }

        return data;
    } catch (error) {
        console.error('Error:', error);
    }
}
