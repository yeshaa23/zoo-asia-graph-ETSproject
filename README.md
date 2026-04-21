# Integrasi Data Kebun Binatang di Asia dari Wikidata dan DBpedia untuk Analisis Graf

## Deskripsi Proyek
Proyek ini bertujuan mengintegrasikan data kebun binatang di Asia dari dua knowledge base terbuka, yaitu Wikidata dan DBpedia, kemudian merepresentasikannya dalam bentuk graf untuk dianalisis menggunakan algoritma graf.

## Tujuan
- Mengambil data kebun binatang di Asia dari Wikidata dan DBpedia
- Menggabungkan data dari dua sumber menggunakan Python
- Membangun graf dengan node Zoo, Region, Country, dan Year
- Menerapkan algoritma graf (similarity, centrality, dan community) 

## Struktur Data
Node yang digunakan:
- Zoo
- Region
- Country
- Year

Relasi yang digunakan:
- Zoo -> Region
- Zoo -> Country
- Region -> Country
- Zoo -> Year

## File Penting
- `data/raw/` : data mentah hasil ekstraksi dari Wikidata dan DBpedia
- `data/processed/` : data hasil integrasi
- `queries/` : query SPARQL dan Cypher
- `notebooks/` : notebook Python untuk integrasi data
- `images/` : hasil visualisasi/tabel analisis

## Algoritma yang Digunakan
### 1. Jaccard Node Similarity
Menggunakan Jaccard Node Similarity untuk membandingkan node Zoo dengan Zoo lain berdasarkan kesamaan tetangga, yaitu Country, Region, dan Year.
### 2. PageRank Centrality
Menggunakan PageRank untuk mengidentifikasi node paling penting dalam graf. Hasil menunjukkan country seperti Japan dan India memiliki centrality tertinggi.
### 3. Louvain Community Detection
Menggunakan Louvain untuk mendeteksi komunitas alami dalam jaringan. Hasil menunjukkan terbentuknya klaster zoo berdasarkan kedekatan geografis dan administratif.

## Tools
- Python
- Pandas
- Neo4j
- Neo4j Graph Data Science
- Wikidata SPARQL
- DBpedia SPARQL

## Hasil Utama
- Similarity menunjukkan adanya pasangan zoo dengan tingkat kemiripan bertingkat, seperti 1.0, 0.667, 0.5, 0.333, 0.25, dan 0.2
- Centrality menunjukkan country sebagai node paling sentral, terutama Japan dan India
- Community detection menunjukkan klaster yang cukup jelas berdasarkan country dan region

## Penulis
Nama: Ayesha Hana Azkiya (5026231125) dan Amandea Chandiki Larasati (5026231139) 
Mata Kuliah: Graf Pengetahuan
Link Wikidata Project: [Tempel URL halaman Wikidata kamu di sini]
