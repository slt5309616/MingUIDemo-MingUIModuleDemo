using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;
using Assets.Scripts.Com.MingUI;

namespace Assets.NGUI.Scripts.Editor{
    [CustomEditor(typeof (CGrid))] ///
    internal class CGridInspector : UnityEditor.Editor{
        public override void OnInspectorGUI(){
            // 官方说要先这样
            DrawDefaultInspector();
            if (GUILayout.Button("Apply")){
                CGrid g = target as CGrid;
                g.Reposition();
                EditorUtility.SetDirty(g);
            }
        }
    }
}