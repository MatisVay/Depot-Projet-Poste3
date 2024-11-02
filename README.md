#OBJECTIF DU PROJET

Ce projet va récupérer les données du site wttr.in pour les afficher d’une nouvelle manière. 

Mais pas que ! Le script crée un historique journalier des températures en fonction des villes. 
Vous pouvez choisir les villes dont vous voulez voir l’historique, ainsi que la fréquence de récolte des données en configurant le cron avec le tuto ci-dessous. 

Le script fournira donc un fichier au format : “meteo_YYYYMMDD.txt” qui contiendra l’historique des données météo de la journée en fonction des exécutions faites par l'utilisateur et le cron. Pour chaque journée si une exécution est faite, un nouveau fichier sera créé (avec la date de la journée dans le nom), contenant l’historique des exécution (donc aussi les températures relatives au moment de l'exécution) de la journée.

De plus le code rapporte les données collectées dans un fichier JSON, ce modèle sous forme de paires clé/valeur permet un accès et une manipulation plus facile des données de wttr.in.

Si le script n’arrive pas a se connecter a wttr.in un message d’erreur sera ajouté à “meteo_error.log” qui tient l'historique des erreurs rencontrées à la date l’heure précise.

Tous les fichiers a part “recup.html” seront créés s'il n’existe pas déjà dans votre répertoire, inutile de les créer.

#INSTALLATION

Télécharger le fichier Extracteur_Météo.sh et recup.html dans le même répertoire.
Une fois téléchargé et placé dans un répertoire (qui est le même pour les deux fichiers), ouvrir le fichier (dans Notepad++ ou via la commande nano dans le shell) pour le modifier. 

Vous devez changer le chemin du répertoire (à l’endroit marqué au début du code) pour le remplacer par le chemin du répertoire dans lequel vous avez téléchargé les fichiers. 

En effet, tous les fichiers créés et ouverts par le code doivent se situer dans le bon (et le même) répertoire dans un souci de bonne exécution du code.

#EXÉCUTION

Exécuter le code avec la commande “./Extracteur_Météo.sh parametre”, parametre doit prendre la valeur d’une ville. Sans paramètre la ville rentre par défaut est Foix.

#AUTOMATISATION AVEC CRONTAB

Une fois crontab installé sur votre machine, assurez vous que le service soit bien en marche (sudo systemctl start cron), ouvrez le fichier pour le modifier avec “crontab -e”. Ajouter au fichier la ligne suivante, en changeant le chemin d'accès par votre chemin d’accès au répertoire : 

* * * * * /mnt/c/Users/votre_nom_user/votre-repertoire/Extracteur_Météo.sh

Cette tâche permet d’automatiser le script avec sa ville par défaut, vous pouvez changer le premier argument pour changer la ville (et donc récolter ces données météo). Vous pouvez aussi changer les étoiles par ces valeurs respectives pour changer le moment de l'exécution :

La première étoile représente les minutes (0-59) 
La deuxième étoile représente les heures (0-23) 
La troisième étoile représente les jours du mois (1-31)  
La quatrième étoile représente les mois (1-12) 
La cinquième étoile représente les jours de la semaine (0-7, où 0 et 7 représentent tous deux le dimanche) 

Enfin, le script cron actuel s'exécute toutes les minutes car les 5 champs sont des étoiles, a vous de le changer pour modifier le moment de l'exécution. Sauvegarder (ctrl s) et quitter le fichier cron (ctrl x), puis redémarrez le service cron pour appliquer correctement les changements (sudo systemctl restart cron).
