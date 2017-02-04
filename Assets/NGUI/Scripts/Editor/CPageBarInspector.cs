using Assets.Scripts.Com.MingUI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor {
    [CustomEditor(typeof(CPageBar))]
    internal class CPageBarInspector : UIWidgetInspector {
        protected override void DrawCustomProperties() {
            NGUIEditorTools.DrawProperty("lbl", serializedObject, "lbl");
            NGUIEditorTools.DrawProperty("UpBtn", serializedObject, "UpBtn");
            NGUIEditorTools.DrawProperty("DownBtn", serializedObject, "DownBtn");
            NGUIEditorTools.DrawProperty("MaxBtn", serializedObject, "btnMax");
            NGUIEditorTools.DrawProperty("MinBtn", serializedObject, "btnMin");
            NGUIEditorTools.DrawProperty("Min", serializedObject, "_Min");
            NGUIEditorTools.DrawProperty("Max", serializedObject, "_Max");
            NGUIEditorTools.DrawProperty("Step", serializedObject, "Step");
            NGUIEditorTools.DrawProperty("DefaultValue", serializedObject, "DefaultValue");

            base.DrawCustomProperties();
        }
    }
}
