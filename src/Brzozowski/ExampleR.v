Require Import CoqStock.Invs.
Require Import CoqStock.List.
Require Import CoqStock.Listerine.
Require Import CoqStock.Untie.
Require Import CoqStock.WreckIt.

Require Import Brzozowski.Alphabet.
Require Import Brzozowski.ConcatLang.
Require Import Brzozowski.Language.
Require Import Brzozowski.LogicOp.
Require Import Brzozowski.Regex.

(*
The introduction of arbitrary Boolean functions enriches the language of regular expressions.
For example, suppose we desire to represent the set of all sequences having three consecutive 1's
but not those ending in 01 or consisting of 1's only.
The desired expression is easily seen to be:

R = (I.1.1.1.I)\&(I.0.1+1.1^{*})'.
*)
Definition x1 := symbol A1.
Definition x0 := symbol A0.
Definition xI111I := concat I (concat x1 (concat x1 (concat x1 I))).
Definition xI01 := concat I (concat x0 x1).
Definition x11star := concat x1 (star x1).
Definition exampleR := and xI111I (neg (or xI01 x11star)).

Theorem notelem_emptyset: forall (s: str),
  s \notin emptyset_lang.
Proof.
intros.
untie.
Qed.

Lemma test_elem_xI01_101:
  ([A1] ++ [A0] ++ [A1]) \in {{xI01}}.
Proof.
unfold xI01.
destruct_concat_lang.
exists [A1].
exists ([A0] ++ [A1]).
assert ([A1] ++ [A0] ++ [A1] = [A1; A0; A1]). reflexivity.
exists H.
constructor.
- constructor.
  wreckit.
  apply notelem_emptyset.
- destruct_concat_lang.
  exists [A0].
  exists [A1].
  exists eq_refl.
  constructor.
  + constructor.
  + constructor.
Qed.

Lemma test_notelem_xI01_101_false:
  ([A1] ++ [A0] ++ [A1]) \notin {{xI01}}  -> False.
Proof.
unfold not.
intros.
apply H.
apply test_elem_xI01_101.
Qed.

Local Ltac elemt :=
  match goal with
  | [ H : _ \in _ |- _ ] =>
    inversion H; clear H
  | [ |- context [_ \notin _ ] ] =>
    unfold not; intros
  end.

Lemma test_notleme_xI01_empty:
    [] \notin {{xI01}}.
Proof.
elemt.
elemt.
elemt.
subst.
listerine.
elemt.
Qed.

Lemma test_notelem_xI01_10:
  ([A1] ++ [A0]) \notin {{xI01}}.
Proof.
elemt.
elemt.
elemt.
elemt.
elemt.
elemt.
subst.
assert (p ++ [A0] ++ [A1] <> [A1] ++ [A0]).
listerine.
contradiction.
Qed.

Lemma test_notelem_xI01_1110:
  ([A1] ++ [A1] ++ [A1] ++ [A0]) \notin {{xI01}}.
Proof.
elemt.
elemt.
elemt.
elemt.
elemt.
subst.
listerine.
Qed.

Lemma test_notelem_x11star_0:
  [A0] \notin {{ x11star }}.
Proof.
elemt.
elemt.
elemt.
- subst.
  listerine.
  subst.
  elemt.
- elemt.
  + subst. elemt. subst. listerine.
  + subst. invs H1. invs H5. invs H9. listerine.
Qed.

Lemma test_notelem_starx1_0:
  [A0] \notin {{star x1}}.
Proof.
untie.
invs H.
- listerine.
  + apply H1.
    reflexivity.
  + inversion H2.
Qed.

Lemma test_notelem_starx1_10:
  [A1; A0] \notin {{star x1}}.
Proof.
untie.
invs H.
- listerine.
  + contradiction.
  + invs H3.
    invs H4.
    listerine.
  + invs H2.
Qed.

Lemma test_notelem_starx1_110:
  [A1; A1; A0] \notin {{star x1}}.
Proof.
untie.
invs H.
invs H2.
listerine.
apply test_notelem_starx1_10.
assumption.
Qed.

Lemma test_notelem_x11star_1110:
  ([A1] ++ [A1] ++ [A1] ++ [A0]) \notin {{x11star}}.
Proof.
untie.
invs H.
wreckit.
listerine; (try invs H1).
- apply test_notelem_starx1_110.
  assumption.
Qed.

Lemma test_elem_xI111I_1110:
    ([A1] ++ [A1] ++ [A1] ++ [A0]) \in {{xI111I}}.
Proof.
destruct_concat_lang.
exists [].
exists ([A1] ++ [A1] ++ [A1] ++ [A0]).
exists eq_refl.
split.
- constructor.
  wreckit.
  untie.
- destruct_concat_lang.
  exists [A1].
  exists ([A1] ++ [A1] ++ [A0]).
  exists eq_refl.
  split.
  + constructor.
  + destruct_concat_lang.
    exists [A1].
    exists ([A1] ++ [A0]).
    exists eq_refl.
    split.
    * constructor.
    * destruct_concat_lang.
      exists [A1].
      exists [A0].
      exists eq_refl.
      split.
      --- constructor.
      --- constructor.
          wreckit.
          untie.
Qed.

Theorem test_exampleR_1110_elem:
    ([A1] ++ [A1] ++ [A1] ++ [A0]) \in {{exampleR}}.
Proof.
constructor.
untie.
invs H.
destruct H0.
- invs H.
  apply H0.
  apply test_elem_xI111I_1110.
- invs H.
  apply H0.
  constructor.
  untie.
  invs H.
  destruct H1.
  + apply  test_notelem_xI01_1110.
    assumption.
  + apply test_notelem_x11star_1110.
    assumption.
Qed.

Theorem test_exampleR_111_notelem:
    [A1; A1; A1] \notin {{exampleR}}.
Proof.
untie.
invs H.
apply H0.
constructor.
right.
constructor.
untie.
invs H.
apply H1.
constructor.
right.
unfold x11star.
destruct_concat_lang.
exists [A1].
exists [A1; A1].
assert ([A1] ++ [A1; A1] = [A1; A1; A1]). listerine; reflexivity.
exists H.
split.
- constructor.
- apply mk_star_more with (p := [A1]) (q := [A1]).
  + listerine. reflexivity.
  + listerine.
  + constructor.
  + apply mk_star_more with (p := [A1]) (q := []).
    * listerine. reflexivity.
    * listerine.
    * constructor.
    * constructor.
Qed.    
