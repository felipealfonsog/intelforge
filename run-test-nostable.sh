perl Makefile.PL
make

# Ensure sample exists:
mkdir -p docs/samples artifacts
echo "test indicator: example.com 1.1.1.1 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef" > docs/samples/sample1.txt

bin/intelforge run --config config/sample.yml --artifacts artifacts
