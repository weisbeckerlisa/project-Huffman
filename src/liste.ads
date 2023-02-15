-- Définition de structures de données associatives sous forme d'un tableau de LCA

with ABR;

generic
    Capacite: Integer;

package LISTE is


	type T_Liste is limited private;

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
	procedure Enregistrer_Liste (Liste : in out T_Liste;  arbre: in T_Arbre ) with
		Post => Taille_Liste (Liste) = Taille_Liste (Liste)'Old + 1);

	-- Supprimer l'arbre associé à un indice dans une Liste.
	procedure Supprimer_Liste (Liste : in out T_Liste ; Indice: in Integer) with
		Post =>  Taille_Liste (Liste) = Taille_Liste (Liste)'Old - 1; -- un élément de moins


    --Supprimer tous les éléments d'une Liste.
    procedure Vider_Liste (Liste : in out T_Liste) with
		Post => Est_Vide_Liste (Liste);

private

    type T_Liste is array (1..Capacite) of T_Arbre;

end LISTE;
