/* *************************************** */
/* Script Frontend pour le Crados Dex */
/* *************************************** */

//const API_URL = 'http://localhost:5001';
const API_URL = 'http://192.168.1.163:5001';
const CRADOSDEX_IMAGES_URL = `http://192.168.1.163/Node-API-Crados/BACKEND/FILES/`;

// FR: Définir un tableau global pour stocker les Crados récupérés
let cradosdex = [];

async function fetchCrados() {
    try {
        const response = await fetch(`${API_URL}/`);
        cradosdex = await response.json();
        console.log('Crados Dex:', cradosdex);
    } catch (error) {
        console.error('Error fetching Crados Dex:', error);
    }
}

async function fetchRandomCrados() {
    try {
        const response = await fetch(`${API_URL}/random`);
        const data = await response.json();
        console.log('Random Crados:', data);
    } catch (error) {
        console.error('Error fetching random Crados:', error);
    }
}

async function fetchCradosByName(name) {
    try {
        const response = await fetch(`${API_URL}/crados?name=${encodeURIComponent(name)}`);
        const data = await response.json();
        console.log(`Crados with name "${name}":`, data);
    } catch (error) {
        console.error(`Error fetching Crados with name "${name}":`, error);
    }
}

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

/* ******************************************* */
/* Gestion des événements DOMContentLoaded */
/* ******************************************* */

document.addEventListener('DOMContentLoaded', async () => {
    // Fetch all Crados on page load
    await fetchCrados()
        .then(() => {
            // Display the list of Crados in the table
            displayCradosList(cradosdex);

            // Lazy load des images
            lazyLoadImages();
        })
        .catch(error => {
            console.error('Error fetching Crados Dex:', error);
        });

    
});

function lazyLoadImages() {
    const images = document.querySelectorAll('img.lazy');
    const config = {
        rootMargin: '0px 0px 50px 0px',
        threshold: 0
    };

    let observer = new IntersectionObserver((entries, self) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                // Remplacer l'image temporaire (spinner) par l'image réelle
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                self.unobserve(img);
            }
        });
    }, config);

    images.forEach(image => {
        observer.observe(image);
    });
}