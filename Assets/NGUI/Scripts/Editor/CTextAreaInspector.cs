using Assets.Scripts.Com.MingUI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor {
     [CustomEditor(typeof(CTextArea))]
     class CTextAreaInspector : UISpriteInspector {
        private SerializedObject tar;
        protected override void DrawCustomProperties() {
            NGUIEditorTools.DrawProperty("input", serializedObject, "input");
            NGUIEditorTools.DrawProperty("canvas", serializedObject, "canvas");
            base.DrawCustomProperties();
        }
    }
}
