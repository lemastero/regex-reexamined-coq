(* Simplify contains theorems that show that
   Language definitions of regular expressions are equivalent.
*)

Require Import CoqStock.DubStep.
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
TODO: Good First Issue
Create a theorem for and prove a simplification rule below:

## Simplification rules mentioned in the Brzozowski paper.

R + R = R
P + Q = Q + P
(P + Q) + R = P + (Q + R)

R + ∅ = R
∅ + R = R
concat_lang_emptyset_r_is_emptyset: R,∅ = ∅
concat_lang_emptyset_l_is_emptyset: ∅,R = ∅
concat_lang_emptystr_r_is_r: R,λ = R
concat_lang_emptystr_l_is_l: λ,R = R

~∅+X = ~∅
~∅&X = X

~(P+Q) = ~P&~Q
~(P&Q) = ~P+~Q

Q&~λ = Q where nullable(Q) = false

## Extra simplification from the Scott Owen's regular expression re-examined paper

r&r = r
r&s = s&r
(r&s)&t = r&(s&t)
∅&r = ∅

(r,s),t = r,(s,t)

r** = r*
λ* = λ
∅* = λ
neg_lang_neg_lang_is_lang: ~~r = r
*)

Theorem neg_lang_neg_lang_is_lang: forall (r: regex),
  neg_lang (neg_lang {{r}})
  {<->}
  {{r}}.
Proof.
(* TODO: Good First Issue
   You will need to use denotation_is_decidable.
*)
Abort.

Theorem concat_lang_emptyset_l_is_emptyset: forall (r: lang),
  concat_lang emptyset_lang r
  {<->}
  emptyset_lang.
Proof.
split.
- intros.
  invs H.
  invs H1.
- intros.
  invs H.
Qed.

Theorem concat_lang_emptyset_r_is_emptyset: forall (r: lang),
  concat_lang r emptyset_lang
  {<->}
  emptyset_lang.
Proof.
split.
- intros.
  invs H.
  invs H2.
- intros.
  invs H.
Qed.

Theorem concat_lang_emptystr_l_is_l: forall (r: lang),
  concat_lang emptystr_lang r
  {<->}
  r.
Proof.
split.
- intros.
  invs H.
  inversion_clear H1.
  cbn.
  assumption.
- intros.
  destruct_concat_lang.
  exists [].
  exists s.
  exists eq_refl.
  split.
  + constructor.
  + assumption.
Qed.

Theorem concat_lang_emptystr_r_is_r: forall (r: lang),
  concat_lang r emptystr_lang
  {<->}
  r.
Proof.
split.
- intros.
  invs H.
  wreckit.
  subst.
  inversion_clear H2.
  listerine.
  assumption.
- intros.
  destruct_concat_lang.
  exists s.
  exists [].
  assert (s ++ [] = s). listerine. reflexivity.
  exists H0.
  split.
  + assumption.
  + constructor.
Qed.