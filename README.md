# RénovPrix / Aide chantier

Application mobile Android destinée aux artisans et particuliers qui veulent estimer le coût complet d’un chantier de rénovation intérieure.

## Objectif MVP

Le MVP couvre :

1. Calcul des surfaces au sol et murales.
2. Calcul automatique des quantités avec marge de perte.
3. Estimation des matériaux, consommables et outils.
4. Comparaison avec une base de prix interne fictive.
5. Total détaillé par scénario de panier.
6. Export PDF.
7. Préparation à la génération APK Android via Flutter.

## Technologie retenue

Flutter est retenu pour produire une application Android exportable en APK, tout en gardant une architecture évolutive.

## Architecture cible

```text
lib/
  main.dart
  app.dart
  core/
    constants/
    models/
    services/
    utils/
  features/
    project/
    calculator/
    pricing/
    pdf_export/
    history/
  data/
    seed_products.dart
    renovation_ratios.dart
```

## Fonctionnalités prévues

- Création d’un projet.
- Sélection du type de pièce.
- Sélection du type de rénovation : carrelage, parquet, peinture, plinthes.
- Saisie des dimensions.
- Calcul des quantités.
- Comparaison de prix à partir d’une base locale.
- Synthèse du coût minimum, conseillé et premium.
- Export PDF du devis estimatif.
- Historique local des projets.

## Données prix

La première version utilise une base locale fictive pour valider la logique métier. L’architecture prévoit ensuite :

- API produit.
- Import CSV manuel.
- Base interne.
- Scraping légal si autorisé.
- Affiliation e-commerce.

## Génération APK

Pré-requis : Flutter installé.

```bash
flutter pub get
flutter run
flutter build apk --release
```

L’APK sera généré dans :

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Avertissement prix

Les prix affichés sont estimatifs. Ils peuvent varier selon les magasins, les disponibilités, les promotions et les frais de livraison.
