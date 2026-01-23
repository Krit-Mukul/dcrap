// Rates Calculator and Booking Functions

// Show calculator modal
function showCalculator() {
    const modal = document.getElementById('calculatorModal');
    modal.style.display = 'flex';
    updateCalculation(); // Calculate initial value
}

// Close calculator modal
function closeCalculator() {
    const modal = document.getElementById('calculatorModal');
    modal.style.display = 'none';
}

// Update calculation based on selected scrap type and weight
function updateCalculation() {
    const scrapType = document.getElementById('scrapType');
    const weight = document.getElementById('weight');
    const totalAmount = document.getElementById('totalAmount');
    
    if (scrapType && weight && totalAmount) {
        const rate = parseFloat(scrapType.value);
        const kg = parseFloat(weight.value) || 0;
        const total = rate * kg;
        
        totalAmount.textContent = total.toFixed(0);
    }
}

// Book pickup for specific scrap type
function bookPickup(type) {
    // Store the scrap type in sessionStorage
    sessionStorage.setItem('selectedScrapType', type);
    
    // Redirect to signup page
    window.location.href = 'signup.html';
}

// Proceed to booking from calculator
function proceedToBooking() {
    const scrapType = document.getElementById('scrapType');
    const weight = document.getElementById('weight');
    
    // Get selected scrap type name
    const selectedOption = scrapType.options[scrapType.selectedIndex].text;
    const scrapTypeName = selectedOption.split(' - ')[0];
    const kg = weight.value;
    
    // Store booking details
    sessionStorage.setItem('selectedScrapType', scrapTypeName);
    sessionStorage.setItem('scrapWeight', kg);
    
    // Redirect to signup page
    window.location.href = 'signup.html';
}

// Display last updated time
function displayLastUpdated() {
    const lastUpdatedElement = document.getElementById('lastUpdated');
    if (lastUpdatedElement) {
        const now = new Date();
        const options = { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric', 
            hour: '2-digit', 
            minute: '2-digit' 
        };
        lastUpdatedElement.textContent = now.toLocaleDateString('en-IN', options);
    }
}

// Close modal when clicking outside
window.addEventListener('click', function(event) {
    const modal = document.getElementById('calculatorModal');
    if (event.target === modal) {
        closeCalculator();
    }
});

// Close modal on escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeCalculator();
    }
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    displayLastUpdated();
    
    // Check if there's a pre-selected scrap type from another page
    const selectedType = sessionStorage.getItem('selectedScrapType');
    if (selectedType) {
        console.log('Pre-selected scrap type:', selectedType);
        // Could auto-open calculator or highlight the item
    }
});
