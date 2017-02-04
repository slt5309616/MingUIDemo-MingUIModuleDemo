using Assets.Scripts.Com.MingUI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace Assets.NGUI.Scripts.Editor {
    [CanEditMultipleObjects]
    [CustomEditor(typeof(CButtonToggle))] ///
    internal class CButtonToggleInspector : CButtonInspector {
        enum Highlight {
            DoNothing,
            Press,
        }
        protected override void DrawProperties() {
            NGUIEditorTools.DrawProperty("Label", serializedObject, "Label");
            NGUIEditorTools.DrawProperty("relateChild", serializedObject, "relateChild");
            SerializedProperty sp = serializedObject.FindProperty("dragHighlight");
            Highlight ht = sp.boolValue ? Highlight.Press : Highlight.DoNothing;
            GUILayout.BeginHorizontal();
            bool highlight = (Highlight)EditorGUILayout.EnumPopup("Drag Over", ht) == Highlight.Press;
            GUILayout.Space(18f);
            GUILayout.EndHorizontal();
            if (sp.boolValue != highlight) sp.boolValue = highlight;

            DrawTransition();
            DrawColors();

            UIButton btn = target as UIButton;

            if (btn.tweenTarget != null) {
                UISprite sprite = btn.tweenTarget.GetComponent<UISprite>();

                if (sprite != null) {
                    if (NGUIEditorTools.DrawHeader("Sprites")) {
                        NGUIEditorTools.BeginContents();
                        EditorGUI.BeginDisabledGroup(serializedObject.isEditingMultipleObjects);
                        {
                            SerializedObject obj = new SerializedObject(sprite);
                            obj.Update();
                            SerializedProperty atlas = obj.FindProperty("mAtlas");
                            NGUIEditorTools.DrawSpriteField("Normal", obj, atlas, obj.FindProperty("mSpriteName"));
                            obj.ApplyModifiedProperties();

                            NGUIEditorTools.DrawSpriteField("Hover", serializedObject, atlas, serializedObject.FindProperty("hoverSprite"), true);
                            NGUIEditorTools.DrawSpriteField("Pressed", serializedObject, atlas, serializedObject.FindProperty("pressedSprite"), true);
                            NGUIEditorTools.DrawSpriteField("Disabled", serializedObject, atlas, serializedObject.FindProperty("disabledSprite"), true);
                            NGUIEditorTools.DrawSpriteField("Selected", serializedObject, atlas, serializedObject.FindProperty("selectSprite"), true);
                        }
                        EditorGUI.EndDisabledGroup();

                        NGUIEditorTools.DrawProperty("Pixel Snap", serializedObject, "pixelSnap");
                        NGUIEditorTools.EndContents();
                    }
                }
            }

            UIButton button = target as UIButton;
            NGUIEditorTools.DrawEvents("On Click", button, button.onClick);
        }
    }
}
