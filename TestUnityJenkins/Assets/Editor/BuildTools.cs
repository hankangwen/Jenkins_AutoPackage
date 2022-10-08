using UnityEditor;
using UnityEngine;

public class BuildTools
{
    [MenuItem("Build/Build APK")]
    public static void BuildApk()
    {
        // 解析命令行参数
        string[] args = System.Environment.GetCommandLineArgs();
        foreach (var s in args)
        {
            if (s.Contains("--productName:"))
            {
                string productName= s.Split(':')[1];
                // 设置app名字
                PlayerSettings.productName = productName;
            }

            if (s.Contains("--version:"))
            {
                string version = s.Split(':')[1];
                // 设置版本号
                PlayerSettings.bundleVersion = version;
            }
        }
       
        // 执行打包
        BuildPlayerOptions opt = new BuildPlayerOptions();
        opt.scenes = new string[] { "Assets/Scenes/SampleScene.unity" };
        opt.locationPathName = Application.dataPath + "/../Bin/test.apk";
        opt.target = BuildTarget.Android;
        opt.options = BuildOptions.None;

        BuildPipeline.BuildPlayer(opt);

        Debug.Log("Build App Done!");
    }
}
