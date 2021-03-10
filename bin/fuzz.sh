# Helper script to build v8_wasm_compile_fuzzer and run it using some defaults.

BUILD_DIR="out/x64-fuzz"
FUZZER="v8_wasm_compile_fuzzer"

function print_help {
  echo 'fuzz.sh'
  echo '-b build_dir    (out/x64-fuzz)'
  echo '-f fuzzer_name  (v8_wasm_compile_fuzzer)'
  echo '-s testcase     do a single run, instead of fuzzing'
  echo '-m              minimize test case'
}

if ! [[ $(pwd) =~ chromium/src ]]; then
  echo 'not in chromium dir'
  exit 1
fi

while getopts 'b:f:s:mh' opt; do
  case "$opt" in
    b)
      BUILD_DIR=$OPTARG
      ;;
    f)
      FUZZER=$OPTARG
      ;;
    s)
      # single run
      TESTCASE=$OPTARG
      ;;
    m)
      MINIMIZE="-minimize_crash=1"
      # minimize crash
      ;;
    h)
      print_help
      exit
      ;;
  esac
done

# minimizing requires a testcase
if [[ -n "$MINIMIZE" &&  -z "$TESTCASE" ]]; then
  echo "minimizing (-m) requires specifying a test case (-t)"
  exit 1
fi

# allow shortcut form of build dir
if ! [[ $BUILD_DIR =~ ^out/ ]]; then
  BUILD_DIR="out/$BUILD_DIR"
fi

if ! [[ -d "$BUILD_DIR" ]]; then
  echo "$BUILD_DIR does not exist"
  exit 1
fi

autoninja -C "$BUILD_DIR" "$FUZZER"

if [[ -n "$TESTCASE" ]]; then
  # run single test case
  if [[ -z "$MINIMIZE" ]]; then
    echo "${BUILD_DIR}/${FUZZER}" "$TESTCASE"
    "${BUILD_DIR}/${FUZZER}" "$TESTCASE"
  else
    "${BUILD_DIR}/${FUZZER}" "$TESTCASE" "$MINIMIZE" -max_total_time=6000
  fi
else 
  "${BUILD_DIR}/${FUZZER}" -max_len=256 -jobs=12
fi;
