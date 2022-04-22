#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function dtmfgen_sox_bash () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?

  local -A CFG=(
    [rc]="$HOME/.config/sox/$FUNCNAME.rc"
    [vol]=0.1
    [dura]=0.1
    [gap]=0.05
    )
  [ ! -f "${CFG[rc]}" ] || source -- "${CFG[rc]}" --initcfg || return $?

  local LOW_FREQ= HIGH_FREQ=
  local ARG=
  while [ "$#" -ge 1 ]; do
    ARG="$1"; shift
    case "$ARG" in
      :* ) "${ARG#:}" "$@"; return $?;;
      -* ) echo "E: unsupported option: $ARG" >&2; return 3;;
      [a-z]*=* ) CFG["${ARG%%=*}"]="${ARG#*=}";;
      =* | \
      * ) play_sequence "${ARG#=}" || return $?;;
    esac
  done
}


function play_sequence  () {
  local SEQ="$*"
  local BUF=
  while [ -n "$SEQ" ]; do
    BUF="${SEQ:0:1}"
    SEQ="${SEQ:1}"
    decode_one_tone_char "$BUF"
    case "$LOW_FREQ:$HIGH_FREQ" in
      ' ' ) ;;
      [0-9]*:[0-9]* )
        play -q -n \
          synth "${CFG[dura]}" \
          sine "$LOW_FREQ" \
          sine "$HIGH_FREQ" \
          vol "${CFG[vol]}" \
          remix - || return $?$(echo "E: Failed to play tone" >&2)
        [ "${CFG[gap]}" == 0 ] || sleep "${CFG[gap]}" || return $?$(
          echo "E: Failed to wait for gap duration" >&2)
        ;;
      * )
        echo "W: unknown symbol: '$BUF'" >&2;;
    esac
  done
}


function decode_one_tone_char () {
  LOW_FREQ=
  HIGH_FREQ=
  case "$1" in
    [123A] ) LOW_FREQ=697;;
    [456B] ) LOW_FREQ=770;;
    [789C] ) LOW_FREQ=852;;
    '*' | 0 | '#' | D ) LOW_FREQ=941;;
  esac
  case "$1" in
    [147] | '*' ) HIGH_FREQ=1209;;
    [2580] ) HIGH_FREQ=1336;;
    [369] | '#' ) HIGH_FREQ=1477;;
    [ABCD] ) HIGH_FREQ=1633;;
  esac
}










dtmfgen_sox_bash "$@"; exit $?
