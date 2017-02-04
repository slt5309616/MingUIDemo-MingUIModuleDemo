using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;
using UnityEngine;

namespace Assets.NGUI.Scripts.Editor
{
    [CustomEditor(typeof(CCombobox))]
    class CComboboxInspector:UIWidgetInspector
    {
        protected override void DrawCustomProperties()
        {
            NGUIEditorTools.DrawProperty("Btn", serializedObject, "Btn");
            NGUIEditorTools.DrawProperty("List", serializedObject, "List");
            NGUIEditorTools.DrawProperty("Bg", serializedObject, "Bg");
            GUI.changed = false;
            NGUIEditorTools.DrawProperty("MaxListHeight", serializedObject, "_MaxListHeight");
            if (GUI.changed) {
            SerializedProperty sp = serializedObject.FindProperty("_MaxListHeight");
                foreach (GameObject go in Selection.gameObjects) {
                    CCombobox w = go.GetComponent<CCombobox>();
                    if (w != null) {
                        w.MaxListHeight = sp.intValue;
                        return;
                    }
                }
            }
            
            base.DrawCustomProperties();

        }
    }
}
