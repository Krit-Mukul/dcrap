// Contact Form Handling

document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    const formSuccess = document.getElementById('formSuccess');
    const formError = document.getElementById('formError');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Hide any previous messages
            formSuccess.style.display = 'none';
            formError.style.display = 'none';
            
            // Get form data
            const formData = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                phone: document.getElementById('phone').value,
                subject: document.getElementById('subject').value,
                message: document.getElementById('message').value
            };
            
            // Validate form
            if (!validateContactForm(formData)) {
                formError.textContent = '✗ Please fill in all required fields correctly.';
                formError.style.display = 'block';
                return;
            }
            
            // Simulate sending form (in production, this would be an API call)
            console.log('Contact form submitted:', formData);
            
            // Simulate API call with timeout
            setTimeout(() => {
                // Show success message
                formSuccess.style.display = 'block';
                
                // Reset form
                contactForm.reset();
                
                // Scroll to success message
                formSuccess.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                
                // Hide success message after 5 seconds
                setTimeout(() => {
                    formSuccess.style.display = 'none';
                }, 5000);
            }, 1000);
        });
    }
});

// Validate contact form
function validateContactForm(data) {
    // Check name
    if (!data.name || data.name.trim().length < 2) {
        return false;
    }
    
    // Check email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!data.email || !emailRegex.test(data.email)) {
        return false;
    }
    
    // Check phone (basic validation)
    const phoneRegex = /^[\d\s\+\-\(\)]{10,}$/;
    if (!data.phone || !phoneRegex.test(data.phone)) {
        return false;
    }
    
    // Check message
    if (!data.message || data.message.trim().length < 10) {
        return false;
    }
    
    return true;
}

// Add input validation feedback
document.addEventListener('DOMContentLoaded', function() {
    const inputs = document.querySelectorAll('#contactForm input, #contactForm textarea');
    
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateField(this);
        });
        
        input.addEventListener('input', function() {
            // Remove error state when user starts typing
            if (this.classList.contains('error')) {
                this.classList.remove('error');
            }
        });
    });
});

// Validate individual field
function validateField(field) {
    let isValid = true;
    
    if (field.hasAttribute('required') && !field.value.trim()) {
        isValid = false;
    }
    
    if (field.type === 'email') {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        isValid = emailRegex.test(field.value);
    }
    
    if (field.type === 'tel') {
        const phoneRegex = /^[\d\s\+\-\(\)]{10,}$/;
        isValid = phoneRegex.test(field.value);
    }
    
    if (field.tagName === 'TEXTAREA' && field.value.trim().length < 10) {
        isValid = false;
    }
    
    // Add/remove error class
    if (!isValid && field.value) {
        field.classList.add('error');
    } else {
        field.classList.remove('error');
    }
    
    return isValid;
}
