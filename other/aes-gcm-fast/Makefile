aes-gcm.s: process_bytes.s keysetup-vul.s sbox.s consts.s consts-gcm.s authenticate.s tablesetup.s wrapper.s redtable.s finalmul.s
	cat $^ > $@

%.s: %.q
	$(QHASM) < $< > $@

%.q: %.pq
	$(MAQ) $< > $@

%.s: %.c
	clang $(CPPFLAGS) $(CFLAGS) -c -S $^ -o $@
