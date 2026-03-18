/* Serveur Backend Crados Dex */

// init
const fs = require('fs');
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
        console.log('Server CradosDex is listening on ' + port);
    }
);

// FR: création des routes
// EN: creating roads
app.get('/',findAllCrados); // return all crados
app.get('/random',findOneCradosByRandom); // return a random crados
app.get('/crados', findOneCrados); // return one crados


// FR: retourner tous les crados
// EN: return all crados
function findAllCrados(request, reponse) {
    // FR: Lecture du fichier
    // EN: Read file
    let data = fs.readFileSync(CRADOSDEX);

    let cradosdex = JSON.parse(data);

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

    // FR: choisis un crados aléatoire
    // EN: choose a random crados
    let id = 0;
    id = Math.floor(Math.random() * cradosdex.length) + 1;

    // FR: Renvoie tout le json interprété
    // EN: Returns all interpreted json
    reponse.send(cradosdex[id]);
}

// FR: return un crados
// EN: return one crados
function findOneCrados(request, reponse) {

    // init
    const crados = request.query.crados;
    const id = request.query.id;
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