# ==============================================================================
# _abcmake_log.cmake.cmake =====================================================

set(__ABCMAKE_INDENTATION "  ")

if ($ENV{ABCMAKE_EMOJI})
    set(__ABCMAKE_COMPONENT "🔤")
    set(__ABCMAKE_OK "✅")
    set(__ABCMAKE_ERROR "❌")
    set(__ABCMAKE_WARNING "🔶")
    set(__ABCMAKE_NOTE "⬜")
else()
    set(__ABCMAKE_COMPONENT "[ABCMAKE]")
    set(__ABCMAKE_OK        "[DONE]")
    set(__ABCMAKE_ERROR     "[ERROR]")
    set(__ABCMAKE_WARNING   "[WARNING]")
    set(__ABCMAKE_NOTE      "[INFO]")
endif()

function(_abcmake_log INDENTATION MESSAGE)
    string(REPEAT ${__ABCMAKE_INDENTATION} ${INDENTATION} indentation)
    message(STATUS "${indentation}${MESSAGE}")
endfunction()

function(_abcmake_log_ok INDENTATION MESSAGE)
    _abcmake_log(${INDENTATION} "${__ABCMAKE_OK} ${MESSAGE}")
endfunction()

function(_abcmake_log_err INDENTATION MESSAGE)
    _abcmake_log(${INDENTATION} "${__ABCMAKE_ERROR} ${MESSAGE}")
endfunction()

function(_abcmake_log_warn INDENTATION MESSAGE)
    _abcmake_log(${INDENTATION} "${__ABCMAKE_WARNING} ${MESSAGE}")
endfunction()

function(_abcmake_log_note INDENTATION MESSAGE)
    _abcmake_log(${INDENTATION} "${__ABCMAKE_NOTE} ${MESSAGE}")
endfunction()

function(_abcmake_log_header INDENTATION MESSAGE)
    _abcmake_log(${INDENTATION} "${__ABCMAKE_COMPONENT} ${MESSAGE}")
endfunction()


# _abcmake_log.cmake.cmake =====================================================
# ==============================================================================
