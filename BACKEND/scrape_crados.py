###########################################################################################
# Script de scraping pour les Crados
###########################################################################################

import os
import requests
import json
import re
from bs4 import BeautifulSoup
from lxml import html

# URL de base pour les pages
base_url = "https://www.lescrados.com/index.php?d=crados&r=crados1&numero="
base_url2 = "https://www.lescrados.com/index.php?d=crados&r=crados2&numero="

# XPath for title
xpath = "//span[@class='arialnoir9b']"
xPathDescription = "//span[@class='arialnoir9']"

# URL de base pour les images
image_base_url = "https://www.lescrados.com/images/crados/"
image_base_url2 = "https://www.lescrados.com/images/crados2/"

# Répertoire pour sauvegarder les images
directory = "FILES"

# Liste des familles de crados
familles = [
    [ 1, [
        [22, "Degueulos"],
        [35, "Animos"],
        [59, "Gravos"],
        [76, "Crevos"],
        [107, "Dechiros"],
        [131, "Lardos"],
        [159, "Craignos"],
        [168, "Puzzle-Toi - 1"],
        [177, "Puzzle-Toi - 2"],
    ]],
    [ 2, [
        [204, "Degueulos"],
        [238, "Animos"],
        [270, "Gravos"],
        [279, "Puzzle-Toi - 3"],
        [280, "Concours"],
        [289, "Puzzle-Toi - 4"],
        [313, "Crevos"],
        [346, "Dechiros"],
        [369, "Craignos"],
        [386, "Lardos"]
    ]]
]

# Json File
json_file_path = "DATA/cradosdex.json"

# Créer le répertoire s'il n'existe pas
os.makedirs(directory, exist_ok=True)

# Liste pour stocker les données
data = []

# Fonction pour scraper les données et télécharger les images
def scrape_crados():
    for numero in range(1, 387):

        # Version des crados
        version = 1 if numero <= 177 else 2

        # Construire l'URL pour la page actuelle
        if version == 1:
            url = base_url + str(numero)
            image_url = f"{image_base_url}{numero}_grand.jpg"   
        else:
            url = base_url2 + str(numero)
            image_url = f"{image_base_url2}{numero}_grand.jpg"

        print(f" Scrape de l'url {url}")

        try:
            # Récupérer la page
            response = requests.get(url)
            response.raise_for_status()

            print(f"        Status: {response.status_code}")

            # Analyser le contenu HTML
            tree = html.fromstring(response.content)

            # Trouver le nom en utilisant l'équivalent XPath en BeautifulSoup
            name_element = tree.xpath(xpath)

            if name_element:

                name = name_element[1].text_content().strip()
                print(f"Page {numero}: {name}")

                # Prénom à extraire de name (uniquement le prénom en majuscule)
                first_name = re.findall(r'\b[A-Z]+\b', name)

                # Description
                description_element = tree.xpath(xPathDescription)
                description = description_element[1].text_content().strip()

                # si First name est vide, on utilise la description pour trouver le prénom
                if not first_name:
                    first_name = re.findall(r'\b[A-Z]+\b', description)
                    if first_name:
                        print(f"Prénom trouvé dans la description: {first_name[0]}")
                    else:
                        print("Prénom non trouvé dans la description.")

                print(f"Description: {description}")

                # Nom trouvé, on cherche l'image correspondante                
                image_response = requests.get(image_url)

                # Famille
                version_famille = familles[version - 1][1]

                # Famille corrspond au numéro en cours
                # Le numéro en cours doit etre inférieur ou égal au numéro de la famille
                famille = next((fam[1] for fam in version_famille if numero <= fam[0]), "Unknown")
                
                print(f"Famille: {famille}")

                if image_response.status_code == 200:
                    image_path = os.path.join(directory, f"{numero:03d}.jpg")

                    with open(image_path, 'wb') as file:
                        file.write(image_response.content)
                    print(f"Image pour {numero} téléchargée avec succès.")


                    # On crée le json correspondant
                    data.append({
                        "id": numero,
                        "version": version==1 and "Crados 1" or "Crados 2",
                        "family": famille,
                        "name": name,
                        "first_name": first_name[0].capitalize(),
                        "description": description
                    })

                    # Écrire les données dans un fichier JSON
                    with open(json_file_path, 'w', encoding='utf-8') as json_file:
                        json.dump(data, json_file, ensure_ascii=False, indent=4)

                else:
                    print(f"Échec du téléchargement de l'image pour {numero}")                

            else:
                print(f"Page {numero}: Nom non trouvé")
                name = f"unknown_{numero}"

        except Exception as e:
            print(f"Erreur lors du traitement de la page {numero}: {e}")

# Executer la fonction de scraping
scrape_crados()
