// Toast Notification System

// Create toast container if it doesn't exist
if (!document.getElementById('toast-container')) {
    const container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'toast-container';
    document.body.appendChild(container);
}

function showEmotionAlert(type, message, suggestions = []) {
    // Create toast element
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
    const toastContainer = document.getElementById('toast-container');
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

// Check for alerts when page loads

