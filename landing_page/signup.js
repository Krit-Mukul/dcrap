// Signup Form Handling

document.addEventListener('DOMContentLoaded', function() {
    const signupForm = document.getElementById('signupForm');
    const signupSuccess = document.getElementById('signupSuccess');
    const signupError = document.getElementById('signupError');
    
    // Check for pre-filled data from rates page
    const selectedScrapType = sessionStorage.getItem('selectedScrapType');
    const scrapWeight = sessionStorage.getItem('scrapWeight');
    
    if (selectedScrapType) {
        console.log('User came from rates page for:', selectedScrapType);
        if (scrapWeight) {
            console.log('With weight:', scrapWeight, 'kg');
        }
        // Could display a message like "Complete registration to book pickup for [scrapType]"
    }
    
    if (signupForm) {
        signupForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Hide any previous messages
            signupSuccess.style.display = 'none';
            signupError.style.display = 'none';
            
            // Get form data
            const formData = {
                fullName: document.getElementById('fullName').value,
                phoneNumber: document.getElementById('phoneNumber').value,
                emailAddress: document.getElementById('emailAddress').value,
                city: document.getElementById('city').value,
                referral: document.getElementById('referral').value,
                terms: document.getElementById('terms').checked,
                updates: document.getElementById('updates').checked,
                // Include scrap type if coming from rates page
                scrapType: selectedScrapType || null,
                scrapWeight: scrapWeight || null
            };
            
            // Validate form
            if (!validateSignupForm(formData)) {
                signupError.textContent = '✗ Please fill in all required fields correctly and accept the terms.';
                signupError.style.display = 'block';
                return;
            }
            
            // Simulate registration (in production, this would be an API call)
            console.log('Signup form submitted:', formData);
            
            // Simulate API call with timeout
            setTimeout(() => {
                // Show success message
                signupSuccess.style.display = 'block';
                
                // Clear session storage
                sessionStorage.removeItem('selectedScrapType');
                sessionStorage.removeItem('scrapWeight');
                
                // Reset form
                signupForm.reset();
                
                // Scroll to success message
                signupSuccess.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                
                // In production, redirect to app download or thank you page after a delay
                // setTimeout(() => {
                //     window.location.href = 'thank-you.html';
                // }, 3000);
            }, 1000);
        });
    }
});

// Validate signup form
function validateSignupForm(data) {
    // Check full name
    if (!data.fullName || data.fullName.trim().length < 3) {
        return false;
    }
    
    // Check phone number (Indian format)
    const phoneRegex = /^[6-9]\d{9}$/;
    const cleanPhone = data.phoneNumber.replace(/[\s\-\+]/g, '').slice(-10);
    if (!phoneRegex.test(cleanPhone)) {
        return false;
    }
    
    // Check email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!data.emailAddress || !emailRegex.test(data.emailAddress)) {
        return false;
    }
    
    // Check city
    if (!data.city) {
        return false;
    }
    
    // Check terms acceptance
    if (!data.terms) {
        return false;
    }
    
    return true;
}

// Add input validation feedback
document.addEventListener('DOMContentLoaded', function() {
    const inputs = document.querySelectorAll('#signupForm input:not([type="checkbox"]), #signupForm select');
    
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateSignupField(this);
        });
        
        input.addEventListener('input', function() {
            // Remove error state when user starts typing
            if (this.classList.contains('error')) {
                this.classList.remove('error');
            }
        });
    });
    
    // Phone number formatting
    const phoneInput = document.getElementById('phoneNumber');
    if (phoneInput) {
        phoneInput.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 10) {
                value = value.slice(-10);
            }
            e.target.value = value;
        });
    }
});

// Validate individual field
function validateSignupField(field) {
    let isValid = true;
    
    if (field.id === 'fullName') {
        isValid = field.value.trim().length >= 3;
    }
    
    if (field.id === 'phoneNumber') {
        const phoneRegex = /^[6-9]\d{9}$/;
        const cleanPhone = field.value.replace(/[\s\-\+]/g, '').slice(-10);
        isValid = phoneRegex.test(cleanPhone);
    }
    
    if (field.id === 'emailAddress') {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        isValid = emailRegex.test(field.value);
    }
    
    if (field.id === 'city') {
        isValid = field.value !== '';
    }
    
    // Add/remove error class
    if (!isValid && field.value) {
        field.classList.add('error');
    } else {
        field.classList.remove('error');
    }
    
    return isValid;
}

// App store button handlers
document.addEventListener('DOMContentLoaded', function() {
    const appStoreButtons = document.querySelectorAll('.app-store-btn');
    
    appStoreButtons.forEach(button => {
        button.addEventListener('click', function() {
            const btnText = this.querySelector('.btn-large').textContent;
            
            if (btnText.includes('App Store')) {
                console.log('Redirecting to iOS App Store...');
                // window.location.href = 'https://apps.apple.com/app/dcrap';
            } else {
                console.log('Redirecting to Google Play Store...');
                // window.location.href = 'https://play.google.com/store/apps/details?id=com.dcrap.app';
            }
        });
    });
});
