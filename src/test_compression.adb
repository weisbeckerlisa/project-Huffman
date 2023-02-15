with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with HUFFMAN; use HUFFMAN;  

procedure Test_Compression is
    Liste: T_Liste;
    Arbre_Huffman: T_Arbre;
    Table_Huffman: T_Table;
    Code_arbre: Unbounded_String:= To_Unbounded_String("");
    Texte_Compresse: Unbounded_String:= To_Unbounded_String("");
    code_carac: Unbounded_String:= To_Unbounded_String("");
begin
    
    Get_Frequence(Liste, "texte_aleatoire.txt");
    -- Création de l'arbre de Huffman
    Construire_Arbre(Liste);
    
    Get_Arbre(Liste,Arbre_Huffman);
    
    -- Création de la table de Huffman
    Initialiser_Table(Table_Huffman);
    
    -- On enregistre une valeur défaut dans la première case de la table afin de réserver cet emplacement pour le caractère de fin de texte
    Enregistrer_Table(0,To_Unbounded_String("00000000"),Table_Huffman);
    Construire_Table(Arbre_Huffman,To_Unbounded_String(""),Table_Huffman);
    
    -- On place le caractère de fin de texte en début de table
    rearranger_Table(Table_Huffman);

    -- On récupère la signature de l'arbre: il faut rajouter un 1 à la fin à cause de la manière dont le programme a été fait.
    Coder_Arbre(Arbre_Huffman, Code_arbre);
    Code_Arbre:= Code_arbre & To_Unbounded_String("1");
    
    code_caracteres(Table_Huffman,code_carac);
    Dessiner_Arbre(Arbre_Huffman,0,' ');
    New_Line;
    Dessiner_Table(Table_Huffman);
    
    Texte_Compresse:= Texte_Compresse & code_carac & Code_arbre;

    compresser_Texte("texte_aleatoire.txt", Table_Huffman, Texte_Compresse);

    --On complete avec des 0 pour avoir un nombre fini d'octets

    while not ((length(Texte_Compresse) mod 8) = 0) loop
        Texte_Compresse:=Texte_Compresse & To_Unbounded_String("0");
    end loop;
    New_Line;
    Put_Line(To_String(Texte_Compresse));
   
end Test_Compression;
