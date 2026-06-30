/********************************* */
/* Serveur Backend Crados Dex */
/********************************* */

// init
const fs = require('fs');
const figlet = require('figlet');
const cors = require('cors');
const express = require('express');
const app = express();

// FR: Définir l'emplacement des fichiers bases de données
// EN: Define the location of database files
const CRADOSDEX = "./DATA/cradosdex.json";

// FR: Définir un port 
// EN: Define a port 
const port = 5001;


// FR: Utilisez "cors" pour gérer les en-têtes CORS.
// EN: Use "cors" to manage CORS headers.
app.use(cors());


// FR: lancer le serveur et attendre
// EN: start the server and wait
app.listen(port, '0.0.0.0',
    () => {
        console.clear();
        figlet('Server CradosDex is listening on ' + port, function (err, data) {
            if (err) {
                console.log("Something went wrong...");
                console.dir(err);
                return;
            }
            console.log('Server CradosDex is listening on ' + port);
        });
    }
);

// FR: création des routes
// EN: creating roads
app.get('/api/v1/crados',findAllCrados); // return all crados
app.get('/api/v1/random',findOneCradosByRandom); // return a random crados
app.get('/api/v1/crados/id/:id', findOneCradosById); // return one crados
app.get('/api/v1/crados/name/:name', findOneCradosByName); // return one crados


// FR: retourner tous les crados
// EN: return all crados
function findAllCrados(request, reponse) {
    // FR: Lecture du fichier
    // EN: Read file
    let data = fs.readFileSync(CRADOSDEX);

    let cradosdex = JSON.parse(data);

    // FR: Parse le JSON et ajoute une propriété "image" à chaque crados, qui correspond au nom du fichier image associé à ce crados
    // EN: Parse the JSON and add an "image" property to each crados, which corresponds to the name of the image file associated with this crados
    for (let i = 0; i < cradosdex.length; i++) {
        cradosdex[i].image = getCradosFile(cradosdex[i].id);
    }

    // FR: Renvoie tout le json interprété
    // EN: Returns all interpreted json
    reponse.send(cradosdex);
}

// FR: retourne un crados aléatoire
// EN: return a random crados
function findOneCradosByRandom(request, reponse) {

    // FR: Lecture du fichier
    // EN: Read file
    let data = fs.readFileSync(CRADOSDEX);

    let cradosdex = JSON.parse(data);

    // FR: choisis un nombre aléatoire
    // EN: choose a random number
    let id = 0;
    id = Math.floor(Math.random() * cradosdex.length) + 1;

    // FR: Renvoie le crados aléatoire trouvé
    // EN: Returns the random crados found
    let randomCrados = cradosdex[id];

    // FR: Ajoute une propriété "image" au crados aléatoire, qui correspond au nom du fichier image associé à ce crados
    // EN: Add an "image" property to the random crados, which corresponds to the name of the image file associated with this crados
    randomCrados.image = getCradosFile(randomCrados.id);

    // FR: Renvoie tout le json interprété
    // EN: Returns all interpreted json
    reponse.send(randomCrados);
}

// FR: return un crados by name
// EN: return one crados
function findOneCradosByName(request, reponse) {

    // init
    const crados = request.query.crados;
    const name = request.query.name;
    let cradosData = null;

    // FR: Lecture du fichier
    // EN: Read file
    let data = fs.readFileSync(CRADOSDEX);
    let cradosdex = JSON.parse(data);

    // FR: si un nom de crados est saisie
    // EN: if a crados name is entered
    if (crados) 
    {
        // FR: cherche un crados par son nom
        // EN: search for a crados by name
        for (let i = 0; i < cradosdex.length; i++) {
            if (
                cradosdex[i].name == crados ||
                cradosdex[i].first_name == crados
            ) {
                cradosData = cradosdex[i];
                break;
            }
        }

        if (cradosData) {
            // FR: Renvoie le Crados trouvé
            // EN: Returns the Crados found
            reponse.send(cradosData);
        } else {
            // not found
            reponse.send('Aucun Crados trouvé avec ce nom.');
        }
    } 
    // FR: si un id de crados est saisie
    // EN: if a crados id is entered
    else if(id) {

        // FR: cherche un crados par son id
        // EN: search for a crados by id
        for (let i = 0; i < cradosdex.length; i++) {
            if ( cradosdex[i].id == id) {
                cradosData = cradosdex[i];
                break;
            }
        }

        if (cradosData) {
            // FR: Renvoie le Crados trouvé
            // EN: Returns the Crados found
            reponse.send(cradosData);
        } else {
            // not found
            reponse.send('Aucun Crados trouvé avec cette id.');
        }
    }
     else {
        // erreur
        reponse.send('Veuillez entrer un champ dans l\'URL en utilisant ?crados=nom_du_crados ou ?id=id_crados.');
    }
}

// FR: return un crados by id
// EN: return one crados
function findOneCradosById(request, reponse) {

    // init
    const id = request.params.id;
    let cradosData = null;

    // FR: Lecture du fichier
    // EN: Read file
    let data = fs.readFileSync(CRADOSDEX);
    let cradosdex = JSON.parse(data);

    // FR: cherche un crados par son id
    // EN: search for a crados by id
    for (let i = 0; i < cradosdex.length; i++) {
        if (cradosdex[i].id == id) {
            cradosData = cradosdex[i];
            break;
        }
    }

    if (cradosData) {
        // FR: Renvoie le Crados trouvé
        // EN: Returns the Crados found
        reponse.send(cradosData);
    } else {
        // not found
        reponse.send('Aucun Crados trouvé avec cette id.');
    }
}

// FR: Convertir un id de crados en nom de fichier
// EN: Convert a crados id to file name
function getCradosFile(id) {
    // FR: l'id est un nombre entre 1 et 386, on doit le convertir en un nom de fichier
    // EN: the id is a number between 1 and 386, we need to convert it to a file name
    let fileName = id.toString().padStart(3, '0') + '.jpg';
    return fileName;
}