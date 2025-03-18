// Toggle Mobile Menu
function toggleMenu() {
    const navItemsMobile = document.querySelector('.nav-items-mobile');
    navItemsMobile.classList.toggle('active');
}

// Handle Navigation Clicks
const navItems = document.querySelectorAll('.nav-item');
const contentSections = document.querySelectorAll('.content-section');

navItems.forEach(item => {
    item.addEventListener('click', () => {
        const sectionId = item.dataset.section;
        const section = document.getElementById(sectionId);

        contentSections.forEach(section => {
            section.classList.remove('active');
        });

        section.classList.add('active');

        // Smooth scroll to the section
        section.scrollIntoView({ behavior: 'smooth', block: 'start' });

        // Close the mobile menu after clicking a link
        if (window.innerWidth <= 768) {
            toggleMenu();
        }
    });
});

// Hide Mobile Menu on Scroll
let lastScrollTop = 0;
const mobileMenu = document.querySelector('.mobile-menu');

window.addEventListener('scroll', () => {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

    if (scrollTop > lastScrollTop) {
        // Scrolling down
        mobileMenu.style.top = '-100px';
    } else {
        // Scrolling up
        mobileMenu.style.top = '0';
    }

    lastScrollTop = scrollTop;
});
