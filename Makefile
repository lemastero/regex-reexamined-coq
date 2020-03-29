build:
	coqc comparable.v
	coqc sort.v
	coqc dup.v
	coqc compare_nat.v
	coqc reorder.v
	coqc regex.v
	coqc size.v
	coqc nullable.v
	coqc compare_regex.v
	coqc derive.v
	coqc smart_or.v
	coqc smart.v
	coqc simplified.v
	coqc simple.v
	coqc main.v

clean:
	(rm *.vo || true && rm *.glob || true && rm .*.aux || true)