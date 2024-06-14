#!/bin/bash

set -e

make

TEST_TIMEOUT=60
JOB_TIMEOUT=30s
JOB_ARGS="-t $JOB_TIMEOUT"

declare -a tests=( \
"./cti_wlm" \
"./cti_launch $JOB_ARGS ./support/hello_wait" \
"./cti_launch_badenv $JOB_ARGS" \
"./cti_barrier $JOB_ARGS ./support/hello </dev/null" \
"./cti_callback $JOB_ARGS ./support/hello" \
"./cti_double_daemon $JOB_ARGS" \
"./cti_environment $JOB_ARGS" \
"./cti_file_in $JOB_ARGS" \
"./cti_file_transfer $JOB_ARGS" \
"./cti_kill $JOB_ARGS ./support/hello_wait 15" \
"./cti_kill $JOB_ARGS ./support/hello_wait 9" \
"./cti_kill $JOB_ARGS ./support/hello_wait 0" \
"./cti_ld_preload $JOB_ARGS" \
"./cti_link" \
"./cti_manifest $JOB_ARGS" \
"./cti_redirect $JOB_ARGS" \
"./cti_release_twice $JOB_ARGS" \
"./cti_session $JOB_ARGS" \
"./cti_tool_daemon $JOB_ARGS" \
"./cti_tool_daemon_argv $JOB_ARGS" \
"./cti_tool_daemon_badenv $JOB_ARGS")

# Create test output directory
if [ -d out ]; then
	rm -r out
fi
mkdir -p out

# Run tests
failed=""

# CTI attach test
echo "Running ./cti_info"
flux cancel --all 2>/dev/null ||:
if output=$((
	# Start target job
	flux run -t $JOB_TIMEOUT ./support/hello_wait &
	sleep 2

	# Get and normalize job ID
	jobid=$(flux jobs -n | head -n1 | sed -e "s/^ f/ \xc6\x92/" \
		| sed -e "s/^ //" | cut -d " " -f 1)
	if [ -z "$jobid" ]; then
		echo "Could not find job ID"; exit 1
	else
		timeout $TEST_TIMEOUT ./cti_info -j $jobid
	fi
	flux cancel $jobid
) 2>&1 > out/cti_info.txt); then
	echo "    ./cti_info passed"
else
	cat > out/cti_info.txt <<< "$output"
	echo "    ./cti_info failed"
	failed="cti_info $failed"
fi

# All other CTI tests
for test_argv in "${tests[@]}"; do
	flux cancel --all 2>/dev/null ||:
	test=$(cut -d ' ' -f 1 <<< "$test_argv")
	timeout_test_argv="timeout $TEST_TIMEOUT $test_argv"

	echo Running $test_argv
	if output=$(eval "$timeout_test_argv" 2>&1); then
		echo "    $test passed"
	else
		cat > out/$test.txt <<< "$test_argv"
		cat >> out/$test.txt <<< "$output"
		echo "    $test failed"
		failed="$test $failed"
	fi

done

# Print failed logs
for test in $failed; do
	echo Failed: $test
	cat out/$test.txt
	echo
done
