with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

generic

    Type T_Caractere is private;


package ABR is

    type T_Arbre is limited private;


	-- Initialiser une Arbre.  L'Arbre est vide.
	procedure Initialiser(Arbre: out T_Arbre) with
		Post => Est_Vide (Arbre);


	-- Est-ce qu'une Arbre est vide ?
	function Est_Vide (Arbre : T_Arbre) return Boolean;


	-- Obtenir le nombre d'éléments d'une Arbre.
	function Taille (Arbre : in T_Arbre) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Arbre);


	-- Savoir si un caractère est présente dans une Arbre.
	--function Caractere_Present (Arbre : in T_Arbre ; Caractere : in T_Caractere) return Boolean;


	-- Obtenir l'occurence associée à un caractère dans l'arbre.
	-- Exception : Caractere_Absent_Exception si le caractère n'est pas utilisé dans l'Arbre
	--function L_Occurence (Arbre : in T_Arbre ; Caractere : in T_Caractere) return Integer;


	-- Supprimer tous les éléments d'une Arbre.
	procedure Vider (Arbre : in out T_Arbre) with
            Post => Est_Vide (Arbre);


private

    Type T_Cellule;

    Type T_Arbre is access T_Cellule;

    Type T_Cellule is
        record
            Occurence: Integer;
            Caractere: T_Caractere;
            Sag: T_Arbre;
            Sad: T_Arbre;
        end record;

end ABR;
