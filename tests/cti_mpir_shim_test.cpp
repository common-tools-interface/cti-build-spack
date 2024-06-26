#include "cti_fe_function_test.hpp"

// Test that an app can launch successfully with the MPIR shim
// This is only supported on SLURM systems.

int main(int argc, char* argv[]) {
    auto const appArgv = createSystemArgv(argc, argv, {"sleep", "10"});

    // Override srun with wrapper script srun
    auto oldPath = std::string{::getenv("PATH") ? ::getenv("PATH") : ""};
    auto newPath = "./support" + (oldPath != "" ? ":" + oldPath : "");
    ::setenv("PATH", newPath.c_str(), 1);

    if (cti_current_wlm() != CTI_WLM_SLURM) {
        std::cerr << "MPIR SHIM only supported on slurm" << std::endl;
        return -1;
    };

    CTIFEFunctionTest app;

    auto const appId = app.watchApp(cti_launchApp(cstrVector(appArgv).data(), -1, -1, nullptr, nullptr, nullptr));
    assert_true(appId > 0, cti_error_str());
    assert_true(cti_appIsValid(appId) == true, cti_error_str());
    std::cerr << "Safe from launch timeout.\n";

    return 0;
}

