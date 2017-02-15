
SELECT DISTINCT [uid], COUNT([uid]) AS total FROM [admin_block] GROUP BY [uid] ORDER BY total DESC

SELECT DISTINCT substring([uid], 2, 40), COUNT([uid]) AS total FROM [admin_block] GROUP BY [uid] ORDER BY total DESC

SELECT * FROM transactions WHERE product_price>9000000

SELECT * FROM club WHERE expenses_total>10000000

--EXEC usp_ResetRemove 'a6fb1d3aa7d3b052b1cf36893ff4cd0c78955ff6'

SELECT * FROM club WHERE balance>20000000

SELECT * FROM club WHERE stadium>100

SELECT * FROM match WHERE match_type_id=3 AND club_away=41935

SELECT DISTINCT [uid], COUNT([uid]) AS total FROM [admin_block] 
WHERE [uid]='07fb8fe44d87bf07f22aaacab7c93f8139f7fd048' 
GROUP BY [uid] ORDER BY total DESC

--EXEC usp_BlockAll

--SUSPENDED
--264f815f87338aa798f8866838945cffef72f60c Van canucks 8
--7e4f3d5a84a8822d5f591e054f6b8c47272d449f 17 SC SLAM

--277d3c06480fceb118edfc5b62d479e8bb7bc9e56 3
--3214de2443276ecbfc3c31749a3802c9402e8adaf 2
--bb02c896315bafd070b437687ddfd8f317e0c5b3 3
--3985df31c2f6e3c4c5c2a6addcb8b23eff976edd 4
--a67f67bc615e8b15bdb86f151aa9c8b1fa450b61
--d846354c9c45f6b21c0b37a598e7b78dc501e221
--aaae94172664e8badc531b2100cd21a306ff7873 2
--ba25433f650fc89188130c9a4189508b50b56a23 20 brampton millers
--a67f67bc615e8b15bdb86f151aa9c8b1fa450b61
--f41f4c99a0a9549bc9a5dd5f25cdc92a6bb7a4cf 2
--bbe197002ba358826a5fd8d5ea93005343ff1d00 2
--a6a17a2b80f11b75dda1b5357e825360094c2b3d
--7578460eac8dd72d45b92b6a20e0069b3c7dbcd5
--69938410e5a99942abc68a699e1eee31505d64b2 7
--9b2d4995919da743b9395363e23d8db8894e3dde 2
--e242229b9f4558083d43824b789092c4fe5d4946
--254e910fe5e5042b7395062e4cffc1d9c1d92ee6 4
--2587ec4a49cd8d783de33ca9fb16c821876db03d 2
--84f7dd7db574fd02c0719081b041d666ddf3482b 5
--9e4821f656b7e1f04ca9577d23a98aeb9a626c4f 3
--3999cedca4d64037d2d891c80f9a4532f3eea19b 6
--cca1b0efbe8fe229d2e9660c3f0055c9ad60159f 5
--aca161ac7b62f9c38b53e3bce7519d48048c14fc 2
--658fb097c20d53a9e14af6da7b33282e2dceb948
--045c12bd6182a30ce5a3714bc1f4c59085faa551
--5ca142396b60195cfddd28e546ecb80a5473b653
--023ef5b71a185043cfabe883a9be7f93f61ef939
--d151f9658daa56879d7b1259ef8c81e03d618b1b 2
--09a4c8c4449885ed80e0c764c2ce33edf496ae7b5 4
--61ce5af593bcf494105df14d83291ceb451226d2 3

(checked until 25/10/2011)
f42956b8378654f977e23996bbb038e5f0e4f473 -A Team
cb3c407d7d53b21f48ef311000047f3c45be13cd
68eb1f077cba8a9c37b45934862a536615d79c31 -Armageddon
8f7d3498f3cdff99aed12d79215edcdccc46882f
5a8187513805b02501ceef07c372a9906ad08c7a
f5024711c0cec5c3b4621d708094882741a1ae59
8fb1086f340a24fdae638bcf1422ed21f54a3c1
6601ed71cf542c5702067759a88da8bbdf91ab94 -Petron Blaze Booster
859928a8bf12526fa63f4519704525f1cda72a9d -River Maya
c55ec6ce960d95ce95f703516bfb68f720d4b4d2 Finland
8fb1086f340a24fdae638bcf1422ed21f54a3c14 Eliran

EXEC usp_block '7e4f3d5a84a8822d5f591e054f6b8c47272d449f'
EXEC usp_ResetRemove '8fb1086f340a24fdae638bcf1422ed21f54a3c14'