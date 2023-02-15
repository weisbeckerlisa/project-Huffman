with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with HUFFMAN; use HUFFMAN;  

procedure test_coder_arbre is
   
    Arbre: T_Arbre;
    sag: T_Arbre;
    sad: T_Arbre;
    sagsag: T_Arbre;
    sagsad:T_Arbre;
    sadsad: T_Arbre;
    Code: Unbounded_String;
    sa1: T_Arbre;
    sa2:T_Arbre;
    sa3: T_Arbre;
    sa4:T_Arbre;
    sa5: T_Arbre;
    sa6:T_Arbre;
    sa7: T_Arbre;
    arbre_test:T_Arbre;
    curseur: T_Arbre;
    
    Table: T_Table;
    code_carac: Unbounded_String;
    
    File: Ada.Streams.Stream_IO.File_Type;
    S: Stream_Access;
    Text: Unbounded_String;
    
    octet: T_Octet:=48;
    
    Caractere: T_Octet;

begin
    
    -- Création d'un arbre quelconque 
    Enregistrer(sa1,20,65);
    Enregistrer(sa2,20,66);
    Enregistrer(sa3,20,67);
    Enregistrer(sa4,20,69);
    Enregistrer(sa5,20,-1);
    Enregistrer(sa6,20,70);
    Enregistrer(sa7,20,71);
    
    Fusion_Arbre(sa1,sa2,sagsag);
    Fusion_Arbre(sa3,sa4,sagsad);
    Fusion_Arbre(sagsag,sagsad,sag);
    Fusion_Arbre(sa6,sa7,sadsad);
    Fusion_Arbre(sa5,sadsad,sad);
    Fusion_Arbre(sag,sad,arbre);
    
    -- Ecriture de la signature de l'arbre
    Code:= To_Unbounded_String("");
    
    Coder_Arbre(Arbre,code);
    Code:= Code & To_Unbounded_String("1");
    Put(To_String(Code));
    
    -- Test de création de la table
    code_carac:=To_Unbounded_String("");
    Initialiser_Table(Table);
    Enregistrer_Table(0,To_Unbounded_String("00000000"),table);
    Construire_Table(Arbre, code_carac, Table);
    New_Line;
    Put(Taille_Table(Table));
    New_Line;
    Put_Line(To_String(get_code(2,Table)));
    rearranger_Table(Table);
    New_Line;
    
    -- Test de l'affichage de la table et de l'arbre.
    Dessiner_Arbre(Arbre,0,'a');
    New_Line;
    New_Line;
    Dessiner_Table(Table);
    
    -- Test conversion
    Put(Convertir_Bits_En_Caractere(To_Unbounded_String("11111111")));
    
    -- Test lecture de fichier
    Open(File, In_File, "test.txt");
    S := Stream(File);
    while not End_Of_File(File) loop
        Caractere := T_Octet'Input(S);
        Put(T_Octet'Image(Caractere));
    end loop;
    Close (File);
    
    -- Tests conversion
    New_Line;
    Put(T_Octet'Image(Convertir_Bits_en_Octet(To_Unbounded_String("00111111"))));
    New_Line;
    Put(To_String(convertir_Octet_en_Bits(Octet)));
    New_Line;
    
    if Octet=Character'Pos('0') then
        Put("ok");
    end if;
end;

