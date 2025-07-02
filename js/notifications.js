// Notification System
const toastContainer = document.getElementById('toast-container');

function createToast(message, suggestions = []) {
    const toast = document.createElement('div');
    toast.className = 'toast';
    
    // Add icon
    const icon = document.createElement('i');
    icon.className = 'toast__icon fas fa-exclamation-triangle';
    
    // Add content
    const content = document.createElement('div');
    content.className = 'toast__content';
    
    const title = document.createElement('div');
    title.className = 'toast__title';
    title.textContent = 'Deteksi Emosi Negatif';
    
    const messageElement = document.createElement('div');
    messageElement.className = 'toast__message';
    messageElement.textContent = message;
    
    content.appendChild(title);
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
    toastContainer.appendChild(toast);
    
    // Remove after duration
    setTimeout(() => {
        toast.classList.add('hide');
        setTimeout(() => {
            toast.remove();
        }, 300); // Wait for animation
    }, 5000);
}

// Check for alerts when page loads
window.addEventListener('load', () => {
    fetch('/api/get_alerts.php')
        .then(response => response.json())
        .then(data => {
            if (data.hasAlert) {
                createToast(data.message, data.suggestions);
            }
        })
        .catch(error => {
            console.error('Error fetching alerts:', error);
        });
});
