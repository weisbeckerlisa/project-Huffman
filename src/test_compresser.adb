with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with HUFFMAN; use HUFFMAN;  

procedure Test_Compresser is
    Liste: T_Liste;
    Arbre_Huffman: T_Arbre;
    Table_Huffman: T_Table;
    Code_arbre: Unbounded_String:= To_Unbounded_String("");
    Texte_Compresse: Unbounded_String:= To_Unbounded_String("");
    code_carac: Unbounded_String:= To_Unbounded_String("");
begin
    
    Get_Frequence(Liste, "test.txt");
    
    -- Création de l'arbre de Huffman
    Construire_Arbre(Liste);
    Arbre_Huffman:=Liste(1);
    
    -- Création de la table de Huffman
    Initialiser_Table(Table_Huffman);
    
    -- On enregistre une valeur défaut dans la première case de la table afin de réserver cet emplacement pour le caractère de fin de texte
    Enregistrer_Table(0,To_Unbounded_String("00000000"),Table_Huffman);
    Construire_Table(Arbre_Huffman,To_Unbounded_String(""),Table);
    
    -- On place le caractère de fin de texte en début de table
    rearranger_Table(Table);
    
    -- On récupère la signature de l'arbre: il faut rajouter un 1 à la fin à cause de la manière dont le programme a été fait.
    Coder_Arbre(Arbre_Huffman, Code_arbre);
    Coder_Arbre:= Code_arbre & To_Unbounded_String("1");
    
    Dessiner_Arbre(Arbre_Huffman,0,' ');
    
    Dessiner_Table(Table_Huffman);
    
    code_caracteres(Table_Huffman,code_carac);
    
    Texte_Compresse:= Texte_Compresse & code_caracteres & Code_arbre;
    
    compresser_Texte("test.txt", Table_Huffman, Texte_Compresse);
    
    --On complete avec des 0 pour avoir un nombre fini d'octets
    
    while not length(To_String(Texte_Compresse))= 0 mod 8 loop
        Texte_Compresse:=Texte_Compresse & To_Unbounded_String("0");
    end loop
    
    Put(To_String(Texte_Compresse));
   
end Test_Compresser;
