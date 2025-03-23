// Variables for burger menu functionality
const burgerMenu = document.getElementById('burger-menu');
const navItemsContainer = document.getElementById('nav-items'); // Container for nav items

// Toggle the menu on small screens
burgerMenu.addEventListener('click', () => {
    navItemsContainer.classList.toggle('active');
});

// Variables for section navigation
const navItems = document.querySelectorAll('.nav-item'); // Individual nav items
const contentSections = document.querySelectorAll('.content-section');

// Handle section navigation
navItems.forEach(item => {
    item.addEventListener('click', () => {
        const sectionId = item.dataset.section;

        // Hide all content sections
        contentSections.forEach(section => {
            section.classList.remove('active');
        });

        // Show the selected content section
        document.getElementById(sectionId).classList.add('active');

        // Collapse the menu on small screens after clicking an item
        if (window.innerWidth <= 768) {
            navItemsContainer.classList.remove('active');
        }
    });
});
