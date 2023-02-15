with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


package HUFFMAN is
    
    type T_Octet is mod 2**8;
    
    Type T_Cellule;

    Type T_Arbre is access T_Cellule;

    Type T_Cellule is
        record
            Occurence: Integer;
            Caractere: T_Octet;
            Sag: T_Arbre;
            Sad: T_Arbre;
        end record;
    
    type T_Liste is array (1..257) of T_Arbre;
    
    Type T_Cellule_case;
    
    Type T_Case is access T_Cellule_case;

    Type T_Cellule_Case is record
        Caractere: T_Octet;
        Code: Unbounded_String;
    end record;

    Type T_Table is array (1..257) of T_Case;


	-- Initialiser une Arbre.  L'Arbre est vide.
	procedure Initialiser(Arbre: out T_Arbre) with
		Post => Est_Vide (Arbre);


	-- Est-ce qu'une Arbre est vide ?
	function Est_Vide (Arbre : T_Arbre) return Boolean;


	-- Obtenir le nombre d'éléments d'une Arbre.
	function Taille (Arbre : in T_Arbre) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Arbre);

	-- Supprimer tous les éléments d'une Arbre.
	procedure Vider (Arbre : in out T_Arbre) with
            Post => Est_Vide (Arbre);
    
    -- Créer un arbre aux sous arbres nuls avec une occurence et un caractère donné (utile pour les tests)
    procedure Enregistrer(Arbre: in out T_Arbre; Occurence: in Integer; Caractere: in T_Octet);

	-- Initialiser une Liste.  La Liste est vide.
	procedure Initialiser_Liste(Liste: out T_Liste) with
		Post => Est_Vide_Liste (Liste);


	-- Est-ce qu'une Liste est vide ?
	function Est_Vide_Liste (Liste : T_Liste) return Boolean;


	-- Obtenir le nombre d'éléments d'une Liste.
	function Taille_Liste (Liste : in T_Liste) return Integer with
		Post => Taille_Liste'Result >= 0
			and (Taille_Liste'Result = 0) = Est_Vide_Liste (Liste);


	-- Enregistrer un arbre dans une liste
	procedure Enregistrer_Liste (Liste : in out T_Liste;  arbre: in T_Arbre );
    
    -- Déterminer si un caractère donné est présent dans la liste.
    function Est_Carac_Present(Liste: in T_Liste; Caractere: in T_Octet) return Boolean;
    
    -- Enregistrer un caractère dans la liste, avec une fréquence de 1
    procedure Enregistrer_Carac(Liste: in out T_Liste; Caractere: in T_Octet);
    
    -- Incrémenter dans la liste l'occurence d'un caractère donné.
    procedure Incrementer_Occurence(Liste: in out T_Liste; Caractere: in T_Octet);
    
	-- Supprimer l'arbre associé à un indice dans une Liste.
	procedure Supprimer_Liste (Liste : in out T_Liste ; Indice: in Integer);


    --Supprimer tous les éléments d'une Liste.
    procedure Vider_Liste (Liste : in out T_Liste) with
		Post => Est_Vide_Liste (Liste);
    
    -- Lire un fichier et initialiser une liste d'arbre contenant chacun un caractère présent dans le texte et sa fréquence
    procedure Get_Frequence(Liste: out T_Liste; Nom_texte: in String);

    --Fusionner deux arbres
    procedure Fusion_Arbre(Arbre1: in T_Arbre; Arbre2: in T_Arbre; Arbre_Fusion: out T_Arbre);

    -- Trouver l'arbre ayant le minimum d'occurence dans la liste et son indice
    procedure min_occurence(liste: in T_Liste; Indice: out Integer; Arbre: out T_Arbre);

    -- Créer l'arbre de Huffman à partir de la liste de fréquence et de caractère
    procedure Construire_Arbre(Liste: in out T_Liste) with
            Post => Taille_Liste(Liste)=1;
    
    -- Récupérer l'arbre de Huffman dans la liste une fois qu'il a été construit dans celle-ci.
    procedure Get_Arbre(Liste: in T_Liste; Arbre: out T_Arbre) with
            Pre => Taille_Liste(Liste)=1;
                    
    -- Creer la table de Huffman a partir de l'arbre de Huffman
    procedure Construire_Table(Arbre: in T_Arbre; code: in Unbounded_String; Table: in out T_Table);

    -- Initialiser une table vide
    procedure Initialiser_Table(Table: out T_Table);
    
    -- Mettre le caractère de fin de texte au début de la table et réarranger les éléments en conséquence. 
    procedure rearranger_Table(Table: in out T_Table);
    
    -- Retourner le bombre d'élément dans une table.
    function Taille_Table(Table: in T_Table) return Integer;

    -- Dessiner l'arbre de Huffan
    procedure Dessiner_Arbre(Arbre : in T_Arbre; etage: in Integer; D_ou_G: in Character);

    -- Dessiner la table de Huffman
    procedure Dessiner_Table(Table: in T_Table);


    --Recréer l'arbre de Huffman à partir des informations contenues dans le texte compressé
    procedure recreer_Arbre(Texte_Compresse: in Unbounded_String; Arbre: out T_Arbre);


    -- Coder l'arbre de Huffman selon un parcours infixe
    procedure Coder_Arbre(Arbre: in T_Arbre; Code: in out Unbounded_String);
    
    -- Récupérer la liste des caractères présent dans la table (en octet) pour créer sa signature
    procedure code_caracteres(Table: in T_Table; code: in out Unbounded_String);
            
    -- Enregistrer le contenu d'une case dans la table de Huffman (un caractère et son code de Huffman)
    procedure Enregistrer_Table(caractere: in T_Octet; Code: in Unbounded_String; Table: in out T_Table);
    
    -- Fonction de test qui renvoie le code contenu dans la case d'indice i de la table
    function get_code(i: in Integer; Table: in T_Table) return Unbounded_String;
    
    -- Renvoie le code de Huffman correspondant à un caractère donné
    function code_huffman(Caracter: in T_octet; Table: in T_Table) return Unbounded_String;
    
    -- Coder chaque caractère du texte selon le codage de HUffman et écrire sa version compressée.
    Procedure compresser_Texte(Texte: in String; Table: in T_Table; Texte_Compresse: in out Unbounded_String);
    
    -- Convertir 8 bits (en unbounded_string) en caractère 
    function Convertir_Bits_En_Caractere(Bits : in Unbounded_String) return Character;
    
    -- Convertir 8 bits (en unbounded_string) en octet (entier entre 0 et 256)
    function Convertir_Bits_en_Octet(Bits : in Unbounded_String) return T_Octet; 
    
    -- COnvertir un octet (entier entre 0 et 255) en 8 bits.
    function convertir_Octet_en_Bits(Octet: in T_Octet) return Unbounded_String;
    
    -- COnvertir un entier (entier entre 0 et 255) en 8 bits.
    function convertir_Entier_en_Bits(Entier: in Integer) return Unbounded_String;
    
    

end HUFFMAN;
