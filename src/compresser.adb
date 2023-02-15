with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Command_Line;      use Ada.Command_Line;
with HUFFMAN; use HUFFMAN;  


procedure compresser is
    Liste: T_Liste;
    Arbre_Huffman: T_Arbre;
    Table_Huffman: T_Table;
    Code_arbre: Unbounded_String:= To_Unbounded_String("");
    Texte_Compresse: Unbounded_String:= To_Unbounded_String("");
    code_carac: Unbounded_String:= To_Unbounded_String("");
    File: Ada.Streams.Stream_IO.File_Type;
    S: Stream_Access;
    File_Name: Unbounded_String;
    Affichage: Boolean:=False;
    Bits: Unbounded_String;
begin
    
    for i in 1..Argument_Count loop
        if Argument(i)="-b" then
            Affichage:=True;
        else
            File_Name:=File_Name & To_Unbounded_String(Argument(i));
        end if;
    end loop;
    
    -- On récupère la liste des caractères présents dans le texte et leur fréquence d'apparition respective. 
    Get_Frequence(Liste, To_String(File_Name));
    
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
    
    -- Si l'utilisateur le souhaite, on affiche l'arbre et la table de Huffman
    if Affichage then
        New_Line;
        Dessiner_Arbre(Arbre_Huffman,0,' ');
        New_Line;
        Dessiner_Table(Table_Huffman);
    end if;
    
    -- On écrit la signature du codage
    Texte_Compresse:= Texte_Compresse & code_carac & Code_arbre;
    
    -- On écrit le texte compressé à la suite
    compresser_Texte(To_String(File_Name), Table_Huffman, Texte_Compresse);
    

    --On complete avec des 0 pour avoir un nombre fini d'octets
    while not ((length(Texte_Compresse) mod 8) = 0) loop
        Texte_Compresse:=Texte_Compresse & To_Unbounded_String("0");
    end loop;
    
    
    -- On écrit le fichier en octet dans un .hff
    Create(File, Out_File, To_String(File_Name & To_Unbounded_String(".hff")));
    S:=Stream(File);
    for i in 1..length(Texte_Compresse)/8-1 loop
        Bits:= To_Unbounded_String(To_String(Texte_Compresse)(i*8..(i+1)*8));
        T_Octet'Write(S, T_Octet(Convertir_Bits_en_Octet(Bits)));
    end loop;
    close(File);
   
end compresser;
