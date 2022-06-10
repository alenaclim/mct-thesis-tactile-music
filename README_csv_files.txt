
This README file explains each of the .csv files in the repository. They are described as used in the R scripts. 
Additionally, columns later generated in R are described, although they do not exist in the original files. 

----------------------------------------------------------------------------------------------------------------------------------

1)	The file named "data.csv" consists of the data generated from the questionnaire, exported from Nettskjema. 
Additionally, it was minimally preprocessed in Excel. Some sum and average variables were calculated. 
Some scores are repeated a number of times for each participant. See below a detailed explanation for 
what each column represents. Shape: 

2)	The file named "data_descriptives.csv" consists of a subset of the "data.csv" file (the following columns: 
"pnr", "age", "gen", "loss", "music", "empathy", "associations"), with only on row per participant.
Additionally, average scores per participant, across the 8 excerpts were calculated. See below details
about each column. Shape:

3)	The file named "excerpts_correlation.csv" consists of average scores for each excerpt, across participants, 
and it is based on the file "data.csv" (similar column "ex"). See below details about each column. Shape: 

----------------------------------------------------------------------------------------------------------------------------------

1)	"data.csv"
Values that were collected/generated once per participant, which are repeated 8 TIMES per participant in the file, 
once for each excerpt (see column "ex"):

	"pnr"		-	participant number (integer, ranged 0-54)
	"age"		-	participants' age (integer)
	"gen"		-	participants' gender (characters, specifically: "Male", "Female", "Other")
	"loss"		-	participants' level of hearing loss (characters, specifically:
					"no"		=	no hearing loss
					"mild"		=	mild hearing loss
					"moderate"	=	moderate hearing loss
					"severe"	=	severe hearing loss
					"profound"	=	profound hearing loss)
	"music"		-	participants' level of musicianship (integer, specifically:
						0	=	non-musician
						1	=	music-loving non-musician
						2	=	amateur musician
						3	=	serious amateur musician
						4	=	semi-professional musician
						5	=	professional musician)
	"empathy"	-	participants' empathy score, as seen in "data_descriptives.csv" (integer)
	"associations"	-	participants' type of associations experienced during the experiment (characters, 
				specifically:
					"no"		=	no associations
					"musical"	=	musical associations
					"imaginative"	=	imaginative associations
					"both"		=	both musical and imaginative associations)
	"avg_valence"	-	participants' average valence score, calculated by averaging the valence scores 
				given for each excerpt (float, 2 decimals)
	"avg_arousal"	-	participants' average arousal score, calculated by averaging the arousal scores
				given for each excerpt (float, 2 decimals)
	"avg_happy_pp"	-	participants' average happiness score, calculated by averaging the recognized
				and felt happiness scores given for each excerpt (float, 2 decimals)
	"avg_sad_pp"	-	participants' average sadness score, calculated by averaging the recognized
				and felt sadness scores given for each excerpt (float, 2 decimals)
	"avg_scary_pp"	-	participants' average scariness score, calculated by averaging the recognized
				and felt scariness scores given for each excerpt (float, 2 decimals)
	"avg_peaceful_pp" -	participants' average peacefulness score, calculated by averaging the recognized
				and felt peacefulness scores given for each excerpt (float, 2 decimals)

Values that were collected/generated 8 times per participant, which are NOT repeated per participant in the file, 
with 8 different values for each excerpt:

	"ex"		-	the excerpt ID (character-integer pair, treated as characters, specifically:
						"H1"	=	happy 1
						"H2" 	=	happy 2
						"T1" 	=	sad 1 (T from the French "triste")
						"T2" 	=	sad 2 (T from the French "triste")
						"P1" 	=	peaceful 1
						"P2" 	=	peaceful 2
						"S1" 	=	scary 1
						"S2" 	=	scary 2)
	"valence"	-	valence score for each excerpt, 8 different scores per participant (integer, 
				ranged 0-9)
	"arousal"	-	arousal score for each excerpt, 8 different scores per participant (integer, 
				ranged 0-9)
	"r_happy"	-	recognized happiness score for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)
	"r_sad"		-	recognized sadness score for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)
	"r_scary"	-	recognized scariness score for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)
	"r_peaceful"	-	recognized peacefulness score for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)
	"f_happy"	-	felt happiness score for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)
	"f_sad"		-	felt sadness score for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)
	"f_scary"	-	felt scariness score for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)
	"f_peaceful"	-	felt peacefulnessscore for each excerpt, 8 different scores per participant
				(integer, ranged 0-9)

Values that were generated 4 times per participant, which are repeated TWICE per participant in the file, 
with 4 different values for each excerpt (one for happiness, sadness, scariness, peacefulness, respectively):

	"avg_happy"	-	average happiness score for each excerpt, calculated as the average between the felt
				happiness score ("f_happy") and recognized happiness score ("r_happy"), only 1 value per
				participant for each excerpt (float, 2 decimals)
	"avg_sad"	-	average sadness score for each excerpt, calculated as the average between the felt
				sadness score ("f_sad") and recognized sadness score ("r_sad"), only 1 value per
				participant for each excerpt (float, 2 decimals)
	"avg_scary"	-	average scariness score for each excerpt, calculated as the average between the felt
				scariness score ("f_scary") and recognized scariness score ("r_scary"), only 1 value per
				participant for each excerpt (float, 2 decimals)
	"avg_peaceful"	-	average peacefulness score for each excerpt, calculated as the average between the felt
				peacefulness score ("f_peaceful") and recognized peacefulness score ("r_peaceful"), only 
				1 value per participant for each excerpt (float, 2 decimals)

Values created in R scripts, with only one value per participant, which do not exist in the original "data.csv":
	
	"music2"	-	participants' level of musicianship based on "music" column (characters, specifically:
					"musician"	=	if value in "music" = 0 or 1
					"non-musician"	=	if value in "music" = 2, 3, 4 or 5

---------------------------------------------------------------------------------------------------------------------------------
			
2)	"data_descriptives.csv"
Values that were generated once per participant, averaging across the scores for each excerpt, in addition to "pnr", "age", 
"gen", "loss", "music", "empathy", "associations", which can be seen above. 

	"valence"	-	average valence score for each participant, calculated by averaging over the valence scores
				of each excerpt = column "valence" in "data.csv" (float, 2 decimals)
	"arousal"	-	average arousal score for each participant, calculated by averaging over the arousal scores
				of each excerpt = column "arousal" in "data.csv" (float, 2 decimals)
	"happiness"	-	average happiness score for each participant, calculated by averaging over the happy scores
				of each excerpt = column "avg_happy" in "data.csv" (float, 2 decimals)
	"sadness"	-	average sadness score for each participant, calculated by averaging over the sadness scores
				of each excerpt = column "avg_sad" in "data.csv" (float, 2 decimals)
	"scariness"	-	average scariness score for each participant, calculated by averaging over the scary scores
				of each excerpt = column "avg_scary" in "data.csv" (float, 2 decimals)
	"peacefulness"	-	average peacefulness score for each participant, calculated by averaging over the peaceful 
				scores of each excerpt = column "avg_peaceful" in "data.csv" (float, 2 decimals)

	"q1" to "q14"	-	scores given by each participant for the 14 questions as part of the IRI index, detailed in
				"Questionnaire.docx" (character, ranged A-E)
	"empathy"	-	participants' empathy score, calculated by summing the corresponding integer values of the data
				in columns "q1" to "q14", according to the instructions found in "Questionnaire.docx" (integer)

Values generated in R which do not exist in the original "data_descriptives.csv":

	"music2"	-	as seen above for "data.csv"
	"loss2"		-	participants' level of hearing loss based on "loss" column (characters, specifically:
					"hearing"	=	if value in "loss" = "no" or "mild"
					"non-hearing"	=	if value in "loss" indicates hearing loss (all other)

-----------------------------------------------------------------------------------------------------------------------------------

3)	"excerpts_correlation.csv"
Values that were generated once per excerpt, averaging across the scores of participants. 

	"ex"		-	excerpt ID, as seen above for "data.csv"
	"happiness"	-	average happiness score for each excerpt, calculated by averaging over the happiness scores
				of each participant = column "happiness" in "data_descriptives" (float, 2 decimals)
	"sadness"	-	average sadness score for each excerpt, calculated by averaging over the sadness scores
				of each participant = column "sadness" in "data_descriptives" (float, 2 decimals)
	"scariness"	-	average scariness score for each excerpt, calculated by averaging over the scariness scores
				of each participant = column "scariness" in "data_descriptives" (float, 2 decimals)
	"peacefulness"	-	average peacefulness score for each excerpt, calculated by averaging over the peaceful scores
				of each participant = column "peacefulness" in "data_descriptives" (float, 2 decimals)
	"valence"	-	average valence score for each excerpt, calculated by averaging over the valence scores
				of each participant = column "valence" in "data_descriptives" (float, 2 decimals)
	"arousal"	-	average arousal score for each excerpt, calculated by averaging over the arousal scores
				of each participant = column "arousal" in "data_descriptives" (float, 2 decimals)
