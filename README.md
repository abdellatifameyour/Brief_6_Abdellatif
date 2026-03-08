# Exploration et Analyse des Données de Facturation Hospitalière avec SQL

## Description du projet

Ce projet consiste à analyser un système de facturation hospitalière à l'aide de **SQL Server**.
La base de données représente le flux complet d’un patient dans un hôpital, depuis la prestation de soins jusqu'à la facturation, le paiement par l’assurance et les ajustements financiers.

L'objectif principal est de développer des compétences en **modélisation relationnelle, manipulation SQL et analyse de données médicales**.

#  Contexte

Les établissements de santé gèrent un volume important de données liées aux patients, aux médecins, aux services médicaux et aux transactions financières.

Dans ce projet, nous analysons une base de données composée de :

* **1 table de faits**
* **8 tables de dimension**

Ce modèle suit une architecture **Star Schema**, couramment utilisée dans les systèmes décisionnels.

Le flux de données est le suivant :

Patient → Service médical → Facturation → Paiement assurance → Ajustement → Compte client.

#  Objectifs du projet

À la fin de ce projet, nous devons être capables de :

* Créer une base de données relationnelle
* Importer des données Excel dans SQL Server
* Définir les **clés primaires et étrangères**
* Comprendre les relations entre les tables
* Utiliser **SELECT, JOIN, GROUP BY, COUNT, SUM**
* Répondre à des questions métier à partir des données

# Technologies utilisées

* **SQL Server**
* **Excel**
* **SQL (Structured Query Language)**


# Structure de la base de données

La base de données contient :

## Table de faits

* `FactTable`

Elle contient les données transactionnelles comme :

* GrossCharge
* Payment
* Adjustment
* CPTUnits
* AR
* type de transaction

## Tables de dimension

Les dimensions permettent de décrire les informations liées aux transactions.

* `DimPatient`
* `DimPhysician`
* `DimDatePost`
* `DimDateService`
* `DimCPTCode`
* `DimPayer`
* `DimTransaction`
* `DimLocation`
* `DimDiagnosisCode`

# ⚙️ Étapes du projet

## 1️⃣ Création de la base de données

Création de la base dans SQL Server :


## 2️⃣ Création des tables

Création de la **table de faits** et des **tables de dimension**.

Chaque table possède une **Primary Key**.

## 3️⃣ Importation des données

Les données sont importées depuis le fichier **Dataset.xlsx** vers SQL Server.

## 4️⃣ Ajout des contraintes

Ajout des **Foreign Keys** dans la table de faits pour relier toutes les dimensions.

# 🔎 Exploration des données

Avant l'analyse, des requêtes simples sont utilisées pour comprendre les données :

# 🔗 Jointures

Les **JOIN** permettent de suivre le parcours complet d’un patient 

# 📈 Requêtes analytiques

## 1️⃣ Nombre de charges > 100$


## 2️⃣ Nombre de patients uniques

## 3️⃣ Nombre de codes CPT par groupe

## 4️⃣ Médecins ayant soumis une réclamation Medicare

## 5️⃣ Codes CPT avec plus de 100 unités

#  Analyses avancées

Le projet inclut également :

* Analyse des paiements par spécialité médicale
* Analyse des diagnostics
* Analyse démographique des patients
* Analyse des ajustements financiers

# Résultats attendus

Grâce à ce projet, nous apprenons à :
* Modéliser une base de données médicale
* Comprendre les flux financiers hospitaliers
* Utiliser SQL pour produire des analyses décisionnelles
* Extraire des informations utiles à partir de données complexes
  
# Auteur

Auteur : **Abdellatif Ameyour**
