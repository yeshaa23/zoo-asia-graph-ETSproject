# SIMILARITY
# projection untuk similarity 
CALL gds.graph.project.cypher(
  'zoo_sim',
  '
  MATCH (n)
  WHERE n:Zoo OR n:Country OR n:Region OR n:Year
  RETURN id(n) AS id, labels(n) AS labels
  ',
  '
  MATCH (z:Zoo)-[r]->(x)
  WHERE (x:Country AND type(r) = "LOCATED_IN")
     OR (x:Region  AND type(r) = "LOCATED_IN")
     OR (x:Year    AND type(r) = "ESTABLISHED_IN")
  RETURN id(z) AS source, id(x) AS target, type(r) AS type
  '
)
YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

# jaccard similarity berdasarkan node country, region, dan published year
CALL gds.nodeSimilarity.stream('zoo_all_sim')
YIELD node1, node2, similarity
WITH gds.util.asNode(node1) AS n1, gds.util.asNode(node2) AS n2, similarity
WHERE n1:Zoo AND n2:Zoo
RETURN
  n1.zooLabel AS zoo1,
  n2.zooLabel AS zoo2,
  similarity
ORDER BY similarity DESC, zoo1, zoo2
LIMIT 20;

# lihat jumlah pasangan per nilai similarity 
CALL gds.nodeSimilarity.stream('zoo_similarity_best')
YIELD node1, node2, similarity
WITH gds.util.asNode(node1) AS z1, gds.util.asNode(node2) AS z2, round(similarity, 3) AS sim
WHERE z1:Zoo AND z2:Zoo
  AND id(z1) < id(z2)
RETURN sim, count(*) AS jumlahPasangan
ORDER BY sim DESC;

# CENTRALITY
# projection analisis dengan algoritma centrality 
CALL gds.nodeSimilarity.stream('zoo_all_sim')
YIELD node1, node2, similarity
WITH gds.util.asNode(node1) AS n1, gds.util.asNode(node2) AS n2, similarity
WHERE n1:Zoo AND n2:Zoo
  AND similarity < 1
  AND similarity > 0
RETURN
  n1.zooLabel AS zoo1,
  n2.zooLabel AS zoo2,
  similarity
ORDER BY similarity DESC, zoo1, zoo2
LIMIT 20;

# pageRank centrality berdasarkan country, region, dan published year
CALL gds.pageRank.stream('zoo_centrality_pr')
YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS n, score
RETURN labels(n) AS nodeType,
       coalesce(n.zooLabel, n.regionLabel, n.countryLabel, toString(n.year), n.name) AS nodeName,
       round(score, 4) AS score
ORDER BY score DESC
LIMIT 20;

# pageRank centrality berdasarkan region (top 5 region)
CALL gds.pageRank.stream('zoo_centrality_pr')
YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS n, score
WHERE n:Region
RETURN
  n.regionLabel AS region,
  score
ORDER BY score DESC
LIMIT 5;

# pageRank centrality berdasarkan country (top 5 country)
CALL gds.pageRank.stream('zoo_centrality_pr')
YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS n, score
WHERE n:Country
RETURN
  n.countryLabel AS country,
  score
ORDER BY score DESC
LIMIT 5;

# pageRank centrality berdasarkan zoo (top 5 zoo)
CALL gds.pageRank.stream('zoo_centrality_pr')
YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS n, score
WHERE n:Region
RETURN
  n.regionLabel AS region,
  score
ORDER BY score DESC
LIMIT 5;

# COMMUNITY
# membuat projection untuk community detection
CALL gds.graph.project.cypher(
  'zoo_community_best',
  '
  MATCH (n)
  WHERE n:Zoo OR n:Country OR n:Region OR n:Year
  RETURN id(n) AS id, labels(n) AS labels
  ',
  '
  MATCH (a)-[r]->(b)
  WHERE (a:Zoo AND b:Country AND type(r) = "LOCATED_IN")
     OR (a:Zoo AND b:Region  AND type(r) = "LOCATED_IN")
     OR (a:Zoo AND b:Year    AND type(r) = "ESTABLISHED_IN")
     OR (a:Region AND b:Country AND type(r) = "PART_OF")
  RETURN id(a) AS source, id(b) AS target, type(r) AS type
  '
)
YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

# hasil jumlah Zoo per komunitas dan contoh Zoo 
CALL gds.louvain.stream('zoo_community_best')
YIELD nodeId, communityId
WITH gds.util.asNode(nodeId) AS n, communityId
WHERE n:Zoo
RETURN
  communityId,
  count(*) AS totalZoos,
  collect(n.zooLabel)[0..15] AS sampleZoos
ORDER BY totalZoos DESC
LIMIT 10;

# lihat region dominan per komunitas 
CALL gds.louvain.stream('zoo_community_best')
YIELD nodeId, communityId
WITH gds.util.asNode(nodeId) AS n, communityId
WHERE n:Zoo
MATCH (n)-[:LOCATED_IN]->(r:Region)
WITH communityId, r.regionLabel AS region, count(*) AS freq
ORDER BY communityId, freq DESC
RETURN
  communityId,
  collect({region: region, count: freq})[0..5] AS topRegions
LIMIT 10;

# lihat country dominan per komunitas 
CALL gds.louvain.stream('zoo_community_best')
YIELD nodeId, communityId
WITH gds.util.asNode(nodeId) AS n, communityId
WHERE n:Zoo
MATCH (n)-[:LOCATED_IN]->(c:Country)
WITH communityId, c.countryLabel AS country, count(*) AS freq
ORDER BY communityId, freq DESC
RETURN
  communityId,
  collect({country: country, count: freq})[0..5] AS topCountries
LIMIT 10;

# community terbesar 
MATCH (z:Zoo)-[:LOCATED_IN]->(r:Region)
MATCH (r)-[:PART_OF]->(c:Country)
WHERE z.communityId = 539
RETURN z, r, c
LIMIT 80;
