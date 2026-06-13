/* *************************************** */
/* Script Frontend pour le Crados Dex */
/* *************************************** */

//const API_URL = 'http://localhost:5001';
const API_URL = 'http://192.168.1.163:5001';
const CRADOSDEX_IMAGES_URL = `http://192.168.1.163/Node-API-Crados/BACKEND/FILES/`;

// FR: Définir un tableau global pour stocker les Crados récupérés
let cradosdex = [];

/**
 * FR: Récupérer tous les Crados depuis l'API
 * EN: Fetch all Crados from the API
 * 
 * @returns {Promise<void>}
 */
async function fetchCrados() {
    try {
        const response = await fetch(`${API_URL}/api/v1/crados`);
        cradosdex = await response.json();
        console.log('Crados Dex:', cradosdex);
    } catch (error) {
        console.error('Error fetching Crados Dex:', error);
    }
}

/**
 * FR: Récupérer un Crados aléatoire depuis l'API
 * EN: Fetch a random Crados from the API
 * 
 * @returns {Promise<void>}
 */
async function fetchRandomCrados() {
    try {
        const response = await fetch(`${API_URL}/random`);
        const data = await response.json();
        console.log('Random Crados:', data);
    } catch (error) {
        console.error('Error fetching random Crados:', error);
    }
}

/**
 * FR: Récupérer un Crados par son nom depuis l'API
 * EN: Fetch a Crados by its name from the API
 * 
 * @param {string} name - Le nom du Crados à récupérer
 * @returns {Promise<void>}
 */
async function fetchCradosByName(name) {
    try {
        const response = await fetch(`${API_URL}/crados?name=${encodeURIComponent(name)}`);
        const data = await response.json();
        console.log(`Crados with name "${name}":`, data);
    } catch (error) {
        console.error(`Error fetching Crados with name "${name}":`, error);
    }
}

/**
 * FR: Afficher les détails d'un Crados dans une div spécifique
 * EN: Display details of a Crados
 * 
 * @param {*} crados 
 */
function displayCrados(crados) {
    const cradosContainer = document.getElementById('crados-container');
    if (cradosContainer) {
        cradosContainer.innerHTML = `
            <h2>${crados.name}</h2>
            <p>ID: ${crados.id}</p>
            <p>Description: ${crados.description}</p>
            <img src="${CRADOSDEX_IMAGES_URL}${crados.image}" class="lazy" alt="${crados.name}" />
        `;
    }
}

/**
 * FR: Afficher les détails d'un Crados aléatoire
 * EN: Display details of a random Crados
 * 
 * @param {*} crados 
 */
function displayRandomCrados(crados) {
    const randomCradosContainer = document.getElementById('random-crados-container');
    if (randomCradosContainer) {
        randomCradosContainer.innerHTML = `
            <h2>${crados.name}</h2>
            <p>ID: ${crados.id}</p>
            <p>Description: ${crados.description}</p>
            <img src="${CRADOSDEX_IMAGES_URL}${crados.image}" alt="${crados.name}" class="lazy" data-src="${CRADOSDEX_IMAGES_URL}${crados.image}" />
        `;
    }
}

/**
 * FR: Afficher la liste des Crados dans un tableau
 * EN: Display the list of Crados in a table
 * 
 * @param {*} cradosList 
 */
function displayCradosList(cradosList) {
    // Récupération du container de la liste des Crados
    const cradosListContainer = document.getElementById('crados-table-body');

    if (cradosListContainer) {
        cradosListContainer.innerHTML = '';

        // Création d'une ligne pour chaque Crados
        cradosList.forEach(crados => {            
            const cradosItem = document.createElement('tr');
            cradosItem.innerHTML = `
                <td>${crados.id}</td>
                <td>${crados.name}</td>
                <td>${crados.description}</td>
                <td>
                    <img src="${CRADOSDEX_IMAGES_URL}spinner.gif" alt="${crados.name}" width="350" class="lazy" data-src="${CRADOSDEX_IMAGES_URL}${crados.image}" />
                </td>
            `;

            // Ajout de la ligne au container
            cradosListContainer.appendChild(cradosItem);
        });
    }
}

/**
 * FR: Fonction de filtre pour la barre de recherche
 * EN: Filter function for the search bar
 */
function filterCrados() {
    const searchInput = document.getElementById('search-bar');
    const filter = searchInput.value.toLowerCase();
    const filteredCrados = cradosdex.filter(crados => crados.name.toLowerCase().includes(filter));
    displayCradosList(filteredCrados);
}



/**
 * FR: Afficher les détails d'un Crados par son nom
 * EN: Display details of a Crados by its name
 * 
 * @param {*} crados 
 */
function displayCradosByName(crados) {
    const cradosByNameContainer = document.getElementById('crados-by-name-container');
    if (cradosByNameContainer) {
        cradosByNameContainer.innerHTML = `
            <h2>${crados.name}</h2>
            <p>ID: ${crados.id}</p>
            <p>Description: ${crados.description}</p>
            <img src="${CRADOSDEX_IMAGES_URL}${crados.image}" alt="${crados.name}" class="lazy" data-src="${CRADOSDEX_IMAGES_URL}${crados.image}" />
        `;
    }
}


/* ******************************************* */
/* Gestion des événements DOMContentLoaded */
/* ******************************************* */

document.addEventListener('DOMContentLoaded', async () => {
    // FR: Récupérer tous les Crados au chargement de la page
    // EN: Fetch all Crados on page load
    await fetchCrados()
        .then(() => {
            // FR: Afficher la liste des Crados dans le tableau
            // EN: Display the list of Crados in the table
            displayCradosList(cradosdex);

            // FR: Lazy load des images
            // EN: Lazy load images
            lazyLoadImages();
        })
        .catch(error => {
            console.error('Error fetching Crados Dex:', error);
        });

    // FR: Gestion de l'événement du bouton de filtrage
    // EN: Handle filter button click event
    const filterButton = document.getElementById('filter-button');
    if (filterButton) {
        filterButton.addEventListener('click', () => {
            filterCrados();
            lazyLoadImages(); // Re-appliquer le lazy load après le filtrage
        });
    }

    
});

/**
 * FR: Lazy load des images pour améliorer les performances
 * EN: Lazy load images to improve performance
 * 
 * @returns {void}
 */
function lazyLoadImages() {
    // FR: Sélectionner toutes les images avec la classe "lazy"
    // EN: Select all images with the class "lazy"
    const images = document.querySelectorAll('img.lazy');
    const config = {
        rootMargin: '0px 0px 50px 0px',
        threshold: 0
    };

    // FR: Créer un IntersectionObserver pour observer les images
    // EN: Create an IntersectionObserver to observe the images
    let observer = new IntersectionObserver((entries, self) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                // FR: Remplacer l'image temporaire (spinner) par l'image réelle
                // EN: Replace the temporary image (spinner) with the actual image
                img.src = img.dataset.src;

                // FR: Supprimer l'attribut data-src pour éviter de recharger l'image
                // EN: Remove the data-src attribute to avoid reloading the image
                img.removeAttribute('data-src');
                self.unobserve(img);
            }
        });
    }, config);

    images.forEach(image => {
        observer.observe(image);
    });
}